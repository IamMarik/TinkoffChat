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
    
    init(channel: Channel) {
        self.channel = channel
    }
    
    func getMessages(successful: @escaping ([Message]) -> Void, failure: @escaping (Error) -> Void) {
        db.collection("channels/\(channel.identifier)/messages").getDocuments { (querySnapshot, err)  in
            if let err = err {
                failure(err)
            } else if let documents = querySnapshot?.documents {
                let messages = documents.compactMap { Message(firestoreData: $0.data()) }
                successful(messages)
            } else {
                
            }
        }
    }
}
