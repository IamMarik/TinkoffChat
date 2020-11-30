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
    
    func avatarService() -> IAvatarService
       
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
        let firestoreSevice = coreAssembly.observeService(parentCollection: "",
                                                          parentIdentifier: "",
                                                          collectionName: "channels",
                                                          modelType: Channel.self)
        
        let channelsService = ChannelsService(firestoreService: firestoreSevice,
                                              serviceAssembly: self,
                                              coreDataStack: coreAssembly.coreDataStack)
        channelsService.logger = logger(for: channelsService)
        return channelsService
    }
    
    func messageService(channelId: String) -> IMessageService {
        let firestoreSevice = coreAssembly.observeService(parentCollection: "channels",
                                                          parentIdentifier: channelId,
                                                          collectionName: "messages",
                                                          modelType: Message.self)
        
        let messageService = MessageService(firestoreService: firestoreSevice,
                                            channelId: channelId,
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
    
    func avatarService() -> IAvatarService {
        let networkManager = coreAssembly.networkManager()
        let privateStore = coreAssembly.privateStore()
        let service = AvatarService(networkManager: networkManager, apiKey: privateStore.pixabayApiKey)
        return service
    }
    
    func logger(for object: Any?) -> ILogger {
        return coreAssembly.logger(for: object)
    }
    
}
