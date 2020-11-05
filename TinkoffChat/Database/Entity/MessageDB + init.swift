//
//  MessageDB + init.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 28.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData
import Firebase

extension MessageDB {
    
    var isMyMessage: Bool {
        return senderId == UserData.shared.identifier
    }
    
    convenience init?(identifier: String, firestoreData: [String: Any], channelId: String, in context: NSManagedObjectContext) {
        guard let content = firestoreData["content"] as? String,
              let senderId = firestoreData["senderId"] as? String,
              let senderName = firestoreData["senderName"] as? String,
              let created = firestoreData["created"] as? Timestamp  else { return nil }
        self.init(context: context)
        self.identifier = identifier
        self.channelId = channelId
        self.content = content
        self.senderId = senderId
        self.senderName = senderName
        self.created = created.dateValue()
    }
    
    convenience init(message: Message, channelId: String, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = message.identifier
        self.content = message.content
        self.senderId = message.senderId 
        self.senderName = message.senderName
        self.created = message.created
        self.channelId = channelId
    }
}
