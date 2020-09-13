//
//  Log.swift
//  TinkoffChat
//
//  Created by Marik on 12.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//
/// Utils class for logging
public class Log {
    /// Set false to disable logging
    static var isEnabled: Bool = true

    /// Print message to console
    static func d(_ message: String) {
        guard isEnabled else { return }
        print(message)
    }

}
