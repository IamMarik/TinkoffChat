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
    func logger(for object: Any?) -> ILogger
}

class CoreAssembly: ICoreAssembly {
    var coreDataStack: ICoreDataStack = CoreDataStack()
    
    func profileDataManager() -> IProfileDataManager {
        let profileDataManager = GCDProfileDataManager()
        profileDataManager.logger = logger(for: profileDataManager)
        return profileDataManager
    }
    
    func logger(for object: Any?) -> ILogger {
        let logger = Logger(for: object)
        return logger
    }
}
