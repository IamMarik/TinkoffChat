//
//  ChannelsData.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 18.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

final class ChannelsService {
    
    private static let logTag = "\(ChannelsService.self)"
    
    private var db = Firestore.firestore()
    
    private var channelsListener: ListenerRegistration?
    
    private lazy var channels: CollectionReference = {
        return db.collection("channels")
    }()
    
    private var fetchesCount = 0
        
    deinit {
        channelsListener?.remove()
    }
        
    /// Create subscription to channel list updates
    func subscribeOnChannelsUpdates(handler: @escaping (Result<Bool, Error>) -> Void) {
        var isFirstFetch = true
        channelsListener = channels.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            
            if let error = error {
                Log.error("Error fetching channels", tag: Self.logTag)
                handler(.failure(error))
            } else if let snapshot = querySnapshot {
                if isFirstFetch {
                    // Удалим все сообщения, на случай если канал удалён, наша бд не должна содержать сообщений
                    // Также это поможет избежать дублирования строк в таблице
                    self.deleteAllChannelsFromDB()
                    isFirstFetch = false
                }
                DispatchQueue.global(qos: .default).async {
                    CoreDataStack.shared.performSave { context in
                        Log.info("Success update channels fetch: \(snapshot.documentChanges.count)", tag: Self.logTag)
                        
                        snapshot.documentChanges.forEach { diff in
                            print(diff.document.data()["name"] ?? "")
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
        let messageService = MessageService(channel: channel)
        channels.document(channel.identifier).collection("messages").getDocuments { (querySnapshot, error) in
            if let error = error {
                Log.error("Error getting messages for deleting", tag: Self.logTag)
                handler(.failure(error))
            } else if let snapshot = querySnapshot {
                snapshot.documents.forEach { document in
                    messageService.deleteMessage(withId: document.documentID, handler: { (error) in
                        Log.error("Error delete nested document", tag: Self.logTag)
                    })
                }
                messageService.deleteAllMessagesFromDB()
                self.channels.document(channel.identifier).delete { error in
                    if let error = error {
                        handler(.failure(error))
                    } else {
                        handler(.success(true))
                    }
                }
            } else {
                handler(.failure(FirebaseError.snapshotIsNil))
            }
        }
    }
     
    private func deleteAllChannelsFromDB() {
        CoreDataStack.shared.performSave { (context) in
            if let result = try? context.fetch(ChannelDB.fetchRequest()) as? [ChannelDB] {
                result.forEach {
                    context.delete($0)
                }
            }
        }
    }
    
}
