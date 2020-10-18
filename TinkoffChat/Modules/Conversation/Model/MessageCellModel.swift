//
//  MessageCellModel.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 27.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

struct MessageCellModel {
    let text: String
    let direction: MessageDirection
}

enum MessageDirection {
    case incoming
    case outgoing
}
