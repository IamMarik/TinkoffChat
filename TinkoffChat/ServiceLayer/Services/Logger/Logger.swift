//
//  Log.swift
//  TinkoffChat
//
//  Created by Dzhanybaev Marat on 12.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol ILogger {
    init(for object: Any?)
    func info(_ message: String, tag: String?)
    func warning(_ message: String, tag: String?)
    func error(_ message: String, tag: String?)
}

extension ILogger {
    func info(_ message: String) { self.info(message, tag: nil) }
    func warning(_ message: String) { self.warning(message, tag: nil) }
    func error(_ message: String) { self.error(message, tag: nil) }
}

/// Util-class for logging
public class Logger: ILogger {
   
    private var classTag: String?

    /// Set false to disable logging
    static var isEnabled: Bool = true

    static var isInfoEnabled: Bool = true

    static var isWarningEnabled: Bool = true

    static var isErrorEnabled: Bool = true
        
    required init(for object: Any?) {
        if let object = object {
            self.classTag = "\(object.self)"
        }
    }
    
    private func tagString(_ suggestedTag: String?) -> String {
        if let tag = suggestedTag {
            return tag
        } else if let classTag = self.classTag {
            return classTag
        } else {
            return ""
        }
    }
    
    func info(_ message: String, tag: String?) {
        let tag = tagString(tag)
        guard Self.isEnabled, Self.isInfoEnabled, !Self.disabledLogTags.contains(tag) else { return }
        print("[Info] " + (tag.isEmpty ? "" : "[\(tag)] ") + message)
    }
    
    func warning(_ message: String, tag: String?) {
        let tag = tagString(tag)
        guard Self.isEnabled, Self.isWarningEnabled, !Self.disabledLogTags.contains(tag) else { return }
        print("[Warning] " + (tag.isEmpty ? "" : "[\(tag)] ") + message)
    }
    
    func error(_ message: String, tag: String?) {
        let tag = tagString(tag)
        guard Self.isEnabled, Self.isErrorEnabled, !Self.disabledLogTags.contains(tag) else { return }
        print("[Error] " + (tag.isEmpty ? "" : "[\(tag)] ") + message)
    }

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
