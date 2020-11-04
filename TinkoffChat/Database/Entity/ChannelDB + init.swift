//
//  ChannelDB + init.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 27.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData
import Firebase

extension ChannelDB {
    convenience init(channel: Channel, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = channel.identifier
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
    
    convenience init?(identifier: String, firestoreData: [String: Any], in context: NSManagedObjectContext) {
        guard let name = firestoreData["name"] as? String,
              !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        self.init(context: context)
        
        self.identifier = identifier
        self.name = name
        self.lastMessage = firestoreData["lastMessage"] as? String
        if let timeStamp = firestoreData["lastActivity"] as? Timestamp {
            self.lastActivity = timeStamp.dateValue()
        } else {
            self.lastActivity = nil
        }
    }
}
