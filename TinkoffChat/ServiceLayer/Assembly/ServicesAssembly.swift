//
//  ServicesAssembly.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 10.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    
    var userDataStore: IUserDataStore { get }
    
    func channelsService() -> IChannelsService
    
    func messageService(channelId: String) -> IMessageService
   
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
        let channelsService = ChannelsService(serviceAssembly: self)
        channelsService.logger = logger(for: channelsService)
        return channelsService
    }
    
    func messageService(channelId: String) -> IMessageService {
        let messageService = MessageService(channelId: channelId, userDataStore: userDataStore)
        messageService.logger = logger(for: messageService)
        return messageService
    }
    
    func logger(for object: Any?) -> ILogger {
        let logger = Log(for: object)
        return logger
    }
    
}
