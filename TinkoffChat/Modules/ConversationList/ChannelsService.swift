//
//  ChannelsData.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 18.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

class ChannelsService {
    
    var db = Firestore.firestore()
    
    private lazy var channels: CollectionReference = {
        return db.collection("channels")
    }()
    
    func getAllChannels(successful: @escaping ([Channel]) -> Void, failure: @escaping (Error) -> Void) {
        channels.getDocuments { (querySnapshot, err) in
            if let err = err {
                failure(err)
            } else if let documents = querySnapshot?.documents {
                
                let channels = documents.compactMap { Channel(identifier: $0.documentID,
                                                              firestoreData: $0.data()) }
                successful(channels)
            } else {
                
            }
        }
    }
    
    func createChannel(name: String, successful: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        var ref: DocumentReference?
        ref = channels.addDocument(data: ["name": name]) { (error) in
            if let error = error {
                failure(error)
            } else {
                if ref?.documentID != nil {
                    successful()
                } else {
                    
                }
            }
        }
    }
    

        
}
