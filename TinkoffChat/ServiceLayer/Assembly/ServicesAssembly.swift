//
//  ServicesAssembly.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 10.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    
    func channelsService() -> IChannelsService
    
    func messageService(channelId: String) -> IMessageService
   
    func logger(for object: Any?) -> ILogger
}

class ServicesAssembly: IServicesAssembly {
    
    func channelsService() -> IChannelsService {
        let channelsService = ChannelsService()
        return channelsService
    }
    
    func messageService(channelId: String) -> IMessageService {
        let messageService = MessageService(channelId: channelId)
        return messageService
    }
    
    func logger(for object: Any?) -> ILogger {
        let logger = Log(for: object)
        return logger
    }
    
}
