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
    
    let channel: Channel
    
    private let db = Firestore.firestore()
    
    lazy var messagesReference = {
        db.collection("channels/\(channel.identifier)/messages")
    }()
    
    var messageListener: ListenerRegistration?
    
    init(channel: Channel) {
        self.channel = channel
    }
    
    deinit {
        messageListener?.remove()
    }
    
    func getMessages(successful: @escaping ([Message]) -> Void, failure: @escaping (Error) -> Void) {
        messagesReference.getDocuments { (querySnapshot, err)  in
            if let err = err {
                failure(err)
            } else if let documents = querySnapshot?.documents {
                let messages = documents
                    .compactMap { Message(firestoreData: $0.data()) }
                    .sorted(by: { $0.created < $1.created })
                successful(messages)
            } else {
                
            }
        }
    }
    
    func subscribeOnMessages(handler: @escaping(Result<[Message], Error>) -> Void) {
        messageListener = messagesReference.addSnapshotListener({ (querySnapshot, error) in
            if let error = error {
                handler(.failure(error))
            } else if let documents = querySnapshot?.documents {
                let messages = documents
                    .compactMap { Message(firestoreData: $0.data()) }
                    .sorted(by: { $0.created < $1.created })
                handler(.success(messages))
            } else {
                handler(.failure(NSError()))
            }
        })
    }
    
    func addMessage(content: String, successful: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        var ref: DocumentReference?
        ref = messagesReference.addDocument(
            data: [
                "content": content,
                "senderId": UserData.shared.identifier,
                "senderName": UserData.shared.name,
                "created": Timestamp(date: Date())
            ]) { (error) in
            if let error = error {
                failure(error)
            } else {
                if ref?.documentID != nil {
                    successful()
                } else {
                    
                }
            }
        }
    }
    
    
}
