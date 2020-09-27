//
//  ConversationSection.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 26.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation


class ConversationSection {
    
    let title: String
    
    var conversations: [ConversationCellModel] = []
    
    init(title: String) {
        self.title = title
    }
}
