//
//  FireStoreObserveService.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 30.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

class FireStoreObserveService<Model: FirestoreModel>: IRemoteStorage {

    private let collectionPath: String
    
    private let parentIdentifier: String
    
    private let db = Firestore.firestore()
    
    private lazy var collectionReference = {
        db.collection(collectionPath)
    }()
    
    private var collectionListener: ListenerRegistration?
    
    private var fetchCount = 0
    
    init(parentCollection: String, parentIdentifier: String, collectionName: String) {
        if parentCollection.isEmpty && parentIdentifier.isEmpty {
            self.collectionPath = collectionName
        } else {
            self.collectionPath = parentCollection + "/" + parentIdentifier + "/" + collectionName
        }
        self.parentIdentifier = parentIdentifier
    }
    
    deinit {
        collectionListener?.remove()
    }
    
    func getList<Model: FirestoreModel>(handler: @escaping (Result<[Model], Error>) -> Void) {
        
        collectionReference.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                handler(.failure(error))
            } else if let snapshot = querySnapshot {
                let documents = snapshot.documents.compactMap { Model(from: $0, parentIdentifier: self.parentIdentifier, changeType: .added)}
                handler(.success(documents))
            } else {
                handler(.failure(FirebaseError.snapshotIsNil))
            }
        }   
    }
    
    func subscribeOnListUpdate<Model: FirestoreModel>(handler: @escaping (Result<[Model], Error>, Int) -> Void) {
        collectionListener = collectionReference.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
           
            if let error = error {
                handler(.failure(error), self.fetchCount)
            } else if let snapshot = querySnapshot {
                self.fetchCount += 1
            
                let documents = snapshot.documentChanges.compactMap { Model(from: $0.document, parentIdentifier: self.parentIdentifier, changeType: $0.type) }
                handler(.success(documents), self.fetchCount)
            } else {
                handler(.failure(FirebaseError.snapshotIsNil), self.fetchCount)
            }
        }
    }
    
    func add<Model: FirestoreModel>(model: Model, handler: @escaping (Result<String, Error>) -> Void) {
        var ref: DocumentReference?
        ref = collectionReference.addDocument(
            data: model.serialize()) { (error) in
            if let error = error {
                handler(.failure(error))
            } else if let documentId = ref?.documentID {
                handler(.success(documentId))
            } else {
                handler(.failure(FirebaseError.referenceIsNil))
            }
        }
    }
    
    func delete(modelWithId identifier: String, handler: @escaping (Error?) -> Void) {
        collectionReference.document(identifier).delete { error in
            if let error = error {
                handler(error)
            } else {
                handler(nil)
            }
        }
    }
    
}
