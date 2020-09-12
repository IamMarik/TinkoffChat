//
//  Log.swift
//  TinkoffChat
//
//  Created by Marik on 12.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

public class Log {

    static var isEnabled: Bool = true

    static func d(_ message: String) {
        guard isEnabled else { return }
        print(message)
    }

}
