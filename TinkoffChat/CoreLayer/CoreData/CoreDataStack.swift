//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 27.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataStack {
    var mainContext: NSManagedObjectContext { get }
    func performSave(_ block: (NSManagedObjectContext) -> Void)
    func addStatisticObserver()
    func deleteStore()
}

final class CoreDataStack: ICoreDataStack {
    
    var logger: ILogger?
        
    private let modelName: String
    
    private let modelExtension: String
    
    init(modelName: String = "ChatModel", modelExtension: String = "momd") {
        self.modelName = modelName
        self.modelExtension = modelExtension
    }
    
    private lazy var storeURL: URL = {
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Documents path not found")
        }
        let url = documentsDirectoryURL.appendingPathComponent("\(modelName).sqlite")
        logger?.info("DB path: " + url.absoluteString)
        return url
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: modelExtension) else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: storeURL,
                                                              options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return persistentStoreCoordinator
    }()
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    private(set) lazy var saveContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext
        context.performAndWait {
            block(context)
            if context.hasChanges {
                do {
                    try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                } catch {
                    logger?.error(error.localizedDescription)
                }                
                performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent { performSave(in: parent) }
    }
  
    func addStatisticObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contextObjectDidChanged(_:)),
                                               name: .NSManagedObjectContextObjectsDidChange,
                                               object: mainContext)
    }
    
    @objc private func contextObjectDidChanged(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let insertCount = (userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>)?.count ?? 0
        let updateCount = (userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>)?.count ?? 0
        let deleteCount = (userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>)?.count ?? 0
        logger?.info("DBContext changes stats: inserted=\(insertCount), updated=\(updateCount), deleted=\(deleteCount)")
    }
        
    func deleteStore() {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            logger?.info("Trying to remove db")
            try coordinator.destroyPersistentStore(at: storeURL,
                                                    ofType: NSSQLiteStoreType,
                                                    options: nil)
            logger?.info("DB was successful removed")
        } catch {
            logger?.error(error.localizedDescription)
        }
    }
    
}
