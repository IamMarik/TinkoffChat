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

protocol IMessageService {
    
    func subscribeOnMessagesUpdates(handler: @escaping(Result<Bool, Error>) -> Void)
    
    func addMessage(content: String, handler: @escaping(Result<String, Error>) -> Void)
    
    func deleteMessage(withId identifier: String, handler: @escaping (Error?) -> Void)
    
    func deleteAllMessages(handler: @escaping (Error?) -> Void)
}

final class MessageService: IMessageService {
  
    private let channelId: String
    
    private let userDataStore: IUserDataStore
    
    private let coreDataStack: ICoreDataStack
    
    var logger: ILogger?
    
    private let messagesFirestoreService: IObserveService
    
    init(channelId: String, firestoreService: IObserveService, userDataStore: IUserDataStore, coreDataStack: ICoreDataStack) {
        self.messagesFirestoreService = firestoreService
        self.channelId = channelId
        self.userDataStore = userDataStore
        self.coreDataStack = coreDataStack
    }
        
    /// Create subscription to message list update
    func subscribeOnMessagesUpdates(handler: @escaping(Result<Bool, Error>) -> Void) {
        
        messagesFirestoreService.subscribeOnListUpdate { [weak self] (result: Result<[Message], Error>, fetchCount) in
            guard let self = self else { return }
                    
            switch result {
            case .success(let messages):
                if fetchCount == 1 {
                    self.deleteAllMessagesFromDB()
                }
                DispatchQueue.global(qos: .default).async {
                    self.coreDataStack.performSave { context in
                        messages.forEach {
                            _ = MessageDB(message: $0, in: context)
                        }
                        handler(.success(true))
                    }
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func deleteAllMessages(handler: @escaping (Error?) -> Void) {
        messagesFirestoreService.getList { [weak self] (result: Result<[Message], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                messages.forEach { message in
                    self.messagesFirestoreService.delete(modelWithId: message.identifier) { (error) in
                        if let error = error {
                            self.logger?.error("Error delete nested document: \(error.localizedDescription)")
                        }
                    }
                    self.deleteAllMessagesFromDB()
                    handler(nil)
                }
            case .failure(let error):
                handler(error)
            }
        }
    }
    
    /// Remove all messages for current channel in Database
    func deleteAllMessagesFromDB() {
        let channelId = self.channelId
        coreDataStack.performSave { (context) in
            if let result = try? context.fetch(MessageDB.fetchRequest(forChannelId: channelId)) {
                result.forEach {
                    context.delete($0)
                }
            }
        }
    }
    
    /// Add a new message to channel
    func addMessage(content: String, handler: @escaping(Result<String, Error>) -> Void) {
        guard let profile = userDataStore.profile else { return }
        
        let message = Message(channelId: channelId,
                              content: content,
                              senderId: userDataStore.identifier,
                              senderName: profile.fullName)
        
        messagesFirestoreService.add(model: message) { (result) in
            switch result {
            case .success(let id):
                handler(.success(id))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    /// Delete message from channel
    func deleteMessage(withId identifier: String, handler: @escaping (Error?) -> Void ) {
        messagesFirestoreService.delete(modelWithId: identifier) { (error) in
            if let error = error {
                self.logger?.error("Error removing message, id: \(identifier). \(error.localizedDescription)")
                handler(error)
            } else {
                self.logger?.info("Message successfully removed, id: \(identifier)")
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
