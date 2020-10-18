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
    
    lazy var messagesReference = {
        db.collection("channels/\(channel.identifier)/messages")
    }()
    
    private let db = Firestore.firestore()
    
    init(channel: Channel) {
        self.channel = channel
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
