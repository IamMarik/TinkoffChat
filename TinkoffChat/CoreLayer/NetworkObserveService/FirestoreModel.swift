//
//  FirestoreModel.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 30.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreModel {
    
    var identifier: String { get }
    var parentIdentifier: String { get }
    
    init?(from change: DocumentChange, parentIdentifier: String)
            
    func serialize() -> [String: Any]
}
