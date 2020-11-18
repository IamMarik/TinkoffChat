//
//  MessagesService.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 18.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase
import CoreData

final class MessageService {
    
    static let logTag = "\(MessageService.self)"
    
    private let channel: ChannelDB
    
    private let channelId: String
    
    private let db = Firestore.firestore()
    
    private lazy var messagesReference = {
        db.collection("channels/\(channel.identifier)/messages")
    }()
    
    private var messagesListener: ListenerRegistration?
    
    init(channel: ChannelDB) {
        self.channel = channel
        self.channelId = channel.identifier
    }
    
    deinit {
        messagesListener?.remove()
    }
    
    /// Create subscription to message list update
    func subscribeOnMessagesUpdates(handler: @escaping(Result<Bool, Error>) -> Void) {
        let channelId = self.channelId
        var isFirstFetch = true
        messagesListener = messagesReference.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                handler(.failure(error))
            } else if let snapshot = querySnapshot {
                if isFirstFetch {
                    // Удалим все сообщения, на случай если канал удалён, наша бд не должна содержать сообщений
                    // Также это поможет избежать дублирования строк в таблице
                    self.deleteAllMessagesFromDB()
                    isFirstFetch = false
                }
                DispatchQueue.global(qos: .default).async {
                    CoreDataStack.shared.performSave { context in
                        snapshot.documentChanges.forEach { diff in
                            switch diff.type {
                            case .added:
                                self.putMessageIn(context: context, document: diff.document, channelId: channelId)             
                            case .modified:
                                self.putMessageIn(context: context, document: diff.document, channelId: channelId)
                            case .removed:
                                self.putMessageIn(context: context, document: diff.document, channelId: channelId)
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
    
    /// Remove all messages for current channel in Database
    func deleteAllMessagesFromDB() {
        let channelId = self.channelId
        CoreDataStack.shared.performSave { (context) in
            if let result = try? context.fetch(MessageDB.fetchRequest(forChannelId: channelId)) {
                result.forEach {
                    context.delete($0)
                }
            }
        }
    }
    
    /// Add a new message to channel
    func addMessage(content: String, handler: @escaping(Result<String, Error>) -> Void) {
        guard let profile = UserData.shared.profile else { return }
        
        var ref: DocumentReference?
        ref = messagesReference.addDocument(
            data: [
                "content": content,
                "senderId": UserData.shared.identifier,
                "senderName": profile.fullName,
                "created": Timestamp(date: Date())
            ]) { (error) in
            if let error = error {
                handler(.failure(error))
            } else if let documentId = ref?.documentID {
                handler(.success(documentId))
            } else {
                handler(.failure(FirebaseError.referenceIsNil))
            }
        }
    }
    
    /// Delete message from channel
    func deleteMessage(withId identifier: String, handler: @escaping (Error?) -> Void ) {
        messagesReference.document(identifier).delete { error in
            if let error = error {
                Log.error("Error removing message, id: \(identifier). \(error.localizedDescription)", tag: Self.logTag)
                handler(error)
            } else {
                Log.info("Message successfully removed, id: \(identifier)", tag: Self.logTag)
                handler(nil)
            }
        }
    }
            
    private func putMessageIn(context: NSManagedObjectContext, document: QueryDocumentSnapshot, channelId: String) {
        _ = MessageDB(identifier: document.documentID,
                      firestoreData: document.data(),
                      channelId: channelId,
                      in: context)
    }
        
}
