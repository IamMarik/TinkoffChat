//
//  ServicesAssembly.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 10.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

protocol IServicesAssembly {
    
    var userDataStore: IUserDataStore { get }
    
    func channelsService() -> IChannelsService
    
    func messageService(channelId: String) -> IMessageService
    
    func channelsFetchResultsController() -> NSFetchedResultsController<ChannelDB>
    
    func messagesFetchResultsController(channelId: String) -> NSFetchedResultsController<MessageDB>
   
    func logger(for object: Any?) -> ILogger
}

class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var userDataStore: IUserDataStore = {
        let userDataStore = UserDataStore(profileDataManager: coreAssembly.profileDataManager())
        return userDataStore
    }()
    
    func channelsService() -> IChannelsService {
        let channelsService = ChannelsService(serviceAssembly: self,
                                              coreDataStack: coreAssembly.coreDataStack)
        channelsService.logger = logger(for: channelsService)
        return channelsService
    }
    
    func messageService(channelId: String) -> IMessageService {
        let messageService = MessageService(channelId: channelId,
                                            userDataStore: userDataStore,
                                            coreDataStack: coreAssembly.coreDataStack)
        messageService.logger = logger(for: messageService)
        return messageService
    }
    
    func channelsFetchResultsController() -> NSFetchedResultsController<ChannelDB> {
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "lastActivity", ascending: false)
        let sortById = NSSortDescriptor(key: "identifier", ascending: true)
        request.sortDescriptors = [sortByDate, sortById]
        request.fetchBatchSize = 20
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: coreAssembly.coreDataStack.mainContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }
    
    func messagesFetchResultsController(channelId: String) -> NSFetchedResultsController<MessageDB> {    
        let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest(forChannelId: channelId)
        let sortByDate = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sortByDate]
        request.fetchBatchSize = 20
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: coreAssembly.coreDataStack.mainContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }
    
    func logger(for object: Any?) -> ILogger {
        let logger = Log(for: object)
        return logger
    }
    
}
