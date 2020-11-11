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
}

class CoreAssembly: ICoreAssembly {
    func profileDataManager() -> IProfileDataManager {
        return GCDProfileDataManager()
    }
    
    var coreDataStack: ICoreDataStack = CoreDataStack()
    
}
