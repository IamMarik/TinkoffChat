//
//  MessagesService.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 18.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

final class MessageService {
    
    private let channel: Channel
    
    private let db = Firestore.firestore()
    
    private lazy var messagesReference = {
        db.collection("channels/\(channel.identifier)/messages")
    }()
    
    private var messagesListener: ListenerRegistration?
    
    init(channel: Channel) {
        self.channel = channel
    }
    
    deinit {
        messagesListener?.remove()
    }
    
    /// Create subscription to message list updates
    func subscribeOnMessages(handler: @escaping(Result<[Message], Error>) -> Void) {
        let channelId = channel.identifier
        messagesListener = messagesReference.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                handler(.failure(error))
            } else if let documents = querySnapshot?.documents {
                // На случай большого списка решил вывести парсинг и сортировку из основного потока
                DispatchQueue.global(qos: .default).async {
                    let messages = documents
                        .compactMap { Message(identifier: $0.documentID, firestoreData: $0.data()) }
                        .sorted(by: { $0.created < $1.created })
                    CoreDataStack.shared.performSave { context in
                        messages.forEach { _ = MessageDB(message: $0, channelId: channelId, in: context) }
                    }
                    handler(.success(messages))
                }
            } else {
                handler(.failure(FirebaseError.snapshotIsNil))
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
    
}
