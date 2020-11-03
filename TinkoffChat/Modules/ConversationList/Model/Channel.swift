//
//  Channel.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 18.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

extension Channel {
    
    init?(identifier: String, firestoreData: [String: Any]) {
        guard let name = firestoreData["name"] as? String else {
            return nil
        }
        self.identifier = identifier
        self.name = name
        self.lastMessage = firestoreData["lastMessage"] as? String
        if let timeStamp = firestoreData["lastActivity"] as? Timestamp {
            self.lastActivity = timeStamp.dateValue()
        } else {
            self.lastActivity = nil
        }
    }
    
    init(dbModel: ChannelDB) {
        self.identifier = dbModel.identifier
        self.name = dbModel.name
        self.lastMessage = dbModel.lastMessage
        self.lastActivity = dbModel.lastActivity
    }
}
