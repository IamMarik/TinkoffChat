//
//  Message.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 18.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

extension Message {
    
    var isMyMessage: Bool {
        return senderId == UserData.shared.identifier
    }
    
    init?(firestoreData: [String: Any]) {
        guard let content = firestoreData["content"] as? String,
              let senderId = firestoreData["senderId"] as? String,
              let senderName = firestoreData["senderName"] as? String,
              let created = firestoreData["created"] as? Timestamp  else { return nil }
        self.content = content
        self.senderId = senderId
        self.senderName = senderName
        self.created = created.dateValue()
    }
}

