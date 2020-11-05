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
    
    func fetchChannels(handler: @escaping (Result<Bool, Error>) -> Void) {
        channels.getDocuments { (querySnapshot, error) in
            if let error = error {
                Log.error("Error fetching all channels")
                handler(.failure(error))
            } else if let documents = querySnapshot?.documents {
                                
                DispatchQueue.global(qos: .default).async {
                    CoreDataStack.shared.performSave { (context) in
                        _ = documents.compactMap {
                            ChannelDB(identifier: $0.documentID,
                                      firestoreData: $0.data(),
                                      in: context)
                            }
                    }
                    
                    DispatchQueue.main.async {
                        handler(.success(true))
                    }
                }
            } else {
                handler(.failure(FirebaseError.snapshotIsNil))
            }
        }
    }
    
    /// Create subscription to channel list updates
    func subscribeOnChannelsUpdates(handler: @escaping (Result<Bool, Error>) -> Void) {
        channelsListener = channels.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            
            if let error = error {
                Log.error("Error fetching channels", tag: Self.logTag)
                handler(.failure(error))
            } else if let snapshot = querySnapshot {
                
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
    
    func deleteChannel(_ channel: ChannelDB, handler: @escaping (Result<Int, Error>) -> Void ) {
        let messageService = MessageService(channel: channel)
        channels.document(channel.identifier).getDocument { (querySnapshot, error) in
            
        }
    }
     
}
