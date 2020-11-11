//
//  DateFormatter + init.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 27.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

extension DateFormatter {

    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}
