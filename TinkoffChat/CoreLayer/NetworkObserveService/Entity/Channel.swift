//
//  Channel.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 01.12.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

struct Channel: FirestoreModel {
    let identifier: String
    let parentIdentifier: String
    let diffType: DocumentChangeType
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init?(from document: DocumentSnapshot, parentIdentifier: String, changeType: DocumentChangeType) {
        guard let data = document.data() else { return nil }
        guard let name = data["name"] as? String,
              !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        self.identifier = document.documentID
        self.parentIdentifier = parentIdentifier
        self.name = name
        self.diffType = changeType
        self.lastMessage = data["lastMessage"] as? String
        self.lastActivity = (data["lastActivity"] as? Timestamp)?.dateValue()
    }
        
    init(name: String) {
        self.identifier = ""
        self.parentIdentifier = ""
        self.diffType = .added
        self.name = name
        self.lastMessage = nil
        self.lastActivity = nil
    }
    
    func serialize() -> [String: Any] {
        return ["name": name]
    }

}
