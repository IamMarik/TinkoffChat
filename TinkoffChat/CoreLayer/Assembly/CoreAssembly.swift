//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 10.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStack: ICoreDataStack { get }
    func profileDataManager() -> IProfileDataManager
    func networkManager() -> INetworkManager
    func privateStore() -> IStore
    func logger(for object: Any?) -> ILogger
    func observeService<Model: FirestoreModel>(parentCollection: String,
                                               parentIdentifier: String,
                                               collectionName: String,
                                               modelType: Model.Type) -> IRemoteStorage
}

class CoreAssembly: ICoreAssembly {
    var coreDataStack: ICoreDataStack = CoreDataStack()
    
    func profileDataManager() -> IProfileDataManager {
        let profileDataManager = GCDProfileDataManager()
        profileDataManager.logger = logger(for: profileDataManager)
        return profileDataManager
    }
    
    func networkManager() -> INetworkManager {
        let manager = NetworkManager()
        return manager
    }
    
    func privateStore() -> IStore {
        return PrivateStore()
    }
    
    func logger(for object: Any?) -> ILogger {
        let logger = Logger(for: object)
        return logger
    }
    
    func observeService<Model: FirestoreModel>(parentCollection: String,
                                               parentIdentifier: String,
                                               collectionName: String,
                                               modelType: Model.Type) -> IRemoteStorage {
        
        let firestoreObserve = FireStoreObserveService<Model>(parentCollection: parentCollection,
                                                              parentIdentifier: parentIdentifier,
                                                              collectionName: collectionName)
        return firestoreObserve
    }
}
