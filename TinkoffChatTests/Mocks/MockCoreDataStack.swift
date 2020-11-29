//
//  MockCoreDataStack.swift
//  TinkoffChatTests
//
//  Created by Марат Джаныбаев on 29.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
@testable import TinkoffChat
import CoreData

final class MockCoreDataStack: ICoreDataStack {
    
    var performSaveCount = 0
    var addStatisticObserverCount = 0
    var deleteStoreCount = 0
        
    var mainContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        performSaveCount += 1
    }
    
    func addStatisticObserver() {
        addStatisticObserverCount += 1
    }
    
    func deleteStore() {
        deleteStoreCount += 1
    }
}
