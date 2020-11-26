//
//  ChannelsData.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 18.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

protocol IChannelsService {
    
    func subscribeOnChannelsUpdates(handler: @escaping (Result<Bool, Error>) -> Void)
    
    func createChannel(name: String, handler: @escaping (Result<String, Error>) -> Void)
    
    func deleteChannel(_ channel: ChannelDB, handler: @escaping (Result<Bool, Error>) -> Void)
}

final class ChannelsService: IChannelsService {
    
    let serviceAssembly: IServicesAssembly
    
    let coreDataStack: ICoreDataStack
    
    var logger: ILogger?
    
    private var db = Firestore.firestore()
    
    private var channelsListener: ListenerRegistration?
    
    private lazy var channels: CollectionReference = {
        return db.collection("channels")
    }()
    
    private var fetchesCount = 0
    
    init(serviceAssembly: IServicesAssembly, coreDataStack: ICoreDataStack) {
        self.serviceAssembly = serviceAssembly
        self.coreDataStack = coreDataStack
    }
        
    deinit {
        channelsListener?.remove()
    }
        
    /// Create subscription to channel list updates
    func subscribeOnChannelsUpdates(handler: @escaping (Result<Bool, Error>) -> Void) {
        var isFirstFetch = true
        channelsListener = channels.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            
            if let error = error {
                self.logger?.error("Error fetching channels")
                handler(.failure(error))
            } else if let snapshot = querySnapshot {
                if isFirstFetch {
                    // Удалим все сообщения, на случай если канал удалён, наша бд не должна содержать сообщений
                    // Также это поможет избежать дублирования строк в таблице
                    self.deleteAllChannelsFromDB()
                    isFirstFetch = false
                }
                DispatchQueue.global(qos: .default).async {
                    self.coreDataStack.performSave { context in
                        self.logger?.info("Success update channels fetch: \(snapshot.documentChanges.count)")
                        
                        snapshot.documentChanges.forEach { diff in
                            let channelName = (diff.document.data()["name"] as? String) ?? ""
                            switch diff.type {
                            case .added, .modified:
                                _ = ChannelDB(identifier: diff.document.documentID,
                                              firestoreData: diff.document.data(),
                                              in: context)
                            case .removed:
                                let id = diff.document.documentID
                                if let result = try? context.fetch(ChannelDB.fetchRequest(withId: id)).first {
                                    context.delete(result)
                                }
                            }
                        }
                        handler(.success(true))
                    }
                }          
            } else {
                handler(.failure(FirebaseError.snapshotIsNil))
            }
        }
    }
    
    func unSubscribeOnChannelsUpdates() {
        channelsListener?.remove()
    }
    
    /// Create a new channel in chanel list with given `name`
    func createChannel(name: String, handler: @escaping (Result<String, Error>) -> Void) {
        var ref: DocumentReference?
        ref = channels.addDocument(data: ["name": name]) { (error) in
            if let error = error {
                handler(.failure(error))
            } else if let channelId = ref?.documentID {
                handler(.success(channelId))
            } else {
                handler(.failure(FirebaseError.referenceIsNil))
            }
        }
    }
    
    // Не смог нормально отладить из-за квоты
    func deleteChannel(_ channel: ChannelDB, handler: @escaping (Result<Bool, Error>) -> Void ) {
        let messageService = serviceAssembly.messageService(channelId: channel.identifier)
        channels.document(channel.identifier).collection("messages").getDocuments { (querySnapshot, error) in
            if let error = error {
                self.logger?.error("Error getting messages for deleting")
                handler(.failure(error))
            } else if let snapshot = querySnapshot {
                snapshot.documents.forEach { document in
                    messageService.deleteMessage(withId: document.documentID, handler: { (error) in
                        self.logger?.error("Error delete nested document")
                    })
                }
                self.channels.document(channel.identifier).delete { error in
                    if let error = error {
                        handler(.failure(error))
                    } else {
                        handler(.success(true))
                    }
                }
                self.deleteAllMessageFromDB(channelId: channel.identifier)
            } else {
                handler(.failure(FirebaseError.snapshotIsNil))
            }
        }
    }
     
    private func deleteAllChannelsFromDB() {
        DispatchQueue.main.async {
            self.coreDataStack.performSave { (context) in
                if let result = try? context.fetch(ChannelDB.fetchRequest()) as? [ChannelDB] {
                    result.forEach {
                        context.delete($0)
                    }
                }
            }
        }
    }
    
    private func deleteAllMessageFromDB(channelId: String) {
        DispatchQueue.main.async {
            self.coreDataStack.performSave { (context) in
                if let result = try? context.fetch(MessageDB.fetchRequest(forChannelId: channelId)) {
                    result.forEach {
                        context.delete($0)
                    }
                }
            }
        }
    }
    
}
