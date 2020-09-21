//
//  Log.swift
//  TinkoffChat
//
//  Created by Dzhanybaev Marat on 12.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation


/// Util-class for logging
public class Log {

    /// Set false to disable logging
    static var isEnabled: Bool = true

    static var isInfoEnabled: Bool = true

    static var isWarningEnabled: Bool = true

    static var isErrorEnabled: Bool = true

    /**
     Множество строковых ключей tag, которые будут исключены из логирования.
     Тэги устанавливаются в `Enviroment Variables` под ключём `disabled_log_tags` разделенных запятой
     */
    private static var disabledLogTags: Set<String> = {
        let disabledLogTags = ProcessInfo.processInfo.environment["disabled_log_tags"]?
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) } ?? []
        return Set(disabledLogTags)
    }()

    /// Print  message to console
    static func info(_ message: String, tag: String = "") {
        guard isEnabled, isInfoEnabled, !disabledLogTags.contains(tag) else { return }
        print("[Info] " + (tag.isEmpty ? "" : "[\(tag)] ") + message)
    }

    static func warning(_ message: String, tag: String = "") {
        guard isEnabled, isWarningEnabled, !disabledLogTags.contains(tag) else { return }
        print("[Warning] " + (tag.isEmpty ? "" : "[\(tag)] ") + message)
    }

    static func error(_ message: String, tag: String = "") {
        guard isEnabled, isErrorEnabled, !disabledLogTags.contains(tag) else { return }
        print("[Error] " + (tag.isEmpty ? "" : "[\(tag)] ") + message)
    }

}
