//
//  Message.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 30.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

struct Message: FirestoreModel {

    let identifier: String
    let content: String
    let senderId: String
    let senderName: String
    let parentIdentifier: String
    let created: Date
    let diffType: DocumentChangeType
    
    init?(from document: DocumentSnapshot, parentIdentifier: String, changeType: DocumentChangeType) {
        guard let data = document.data() else { return nil }
        guard let content = data["content"] as? String,
              let senderId = data["senderId"] as? String,
              let senderName = data["senderName"] as? String,
              let created = data["created"] as? Timestamp  else { return nil }
        self.identifier = document.documentID
        self.content = content
        self.senderId = senderId
        self.senderName = senderName
        self.created = created.dateValue()
        self.parentIdentifier = parentIdentifier
        self.diffType = changeType
    }
                
    init(channelId: String, content: String, senderId: String, senderName: String) {
        self.content = content
        self.senderId = senderId
        self.identifier = ""
        self.senderName = senderName
        self.created = Date()
        self.parentIdentifier = channelId
        self.diffType = .added
    }
    
    func serialize() -> [String: Any] {
        return ["content": content,
                "senderId": senderId,
                "senderName": senderName,
                "created": Timestamp(date: created)]
    }
    
}
