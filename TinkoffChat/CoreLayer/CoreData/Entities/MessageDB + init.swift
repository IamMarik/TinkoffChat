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
        return senderId == UserDataStore.shared.identifier
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
    
}
