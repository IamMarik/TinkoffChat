//
//  MessageCellModel.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 27.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation


struct MessageCellModel {
    let text: String
    let direction: MessageCellType
}

enum MessageCellType {
    case incoming
    case outgoing
}
