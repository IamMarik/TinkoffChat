//
//  MessageDB + init.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 28.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

extension MessageDB {
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
