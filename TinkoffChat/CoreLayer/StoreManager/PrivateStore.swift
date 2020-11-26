//
//  PrivateStore.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol IStore {
    var pixabayApiKey: String { get }
}

class PrivateStore: IStore {
    var pixabayApiKey: String { "19129997-18292933deb8be2554cfdcef3" }
}
