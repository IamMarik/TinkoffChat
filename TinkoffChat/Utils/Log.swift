//
//  Log.swift
//  TinkoffChat
//
//  Created by Marik on 12.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

public class Log {

    static var isEnabled: Bool = false

    static func d(_ message: String) {
        guard isEnabled else { return }
        print(message)
    }

}
