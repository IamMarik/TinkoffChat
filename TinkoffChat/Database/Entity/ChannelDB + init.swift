//
//  ChannelDB + init.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 27.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

extension ChannelDB {
    convenience init(channel: Channel, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = channel.identifier
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
}
