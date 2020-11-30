//
//  ChannelsData.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 18.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol IChannelsService {
    
    func subscribeOnChannelsUpdates(handler: @escaping (Result<Bool, Error>) -> Void)
    
    func createChannel(name: String, handler: @escaping (Result<String, Error>) -> Void)
    
    func deleteChannel(with id: String, handler: @escaping (Result<Bool, Error>) -> Void)
}

final class ChannelsService: IChannelsService {
    
    let serviceAssembly: IServicesAssembly
    
    let coreDataStack: ICoreDataStack
    
    var logger: ILogger?
 
    private let channelsFirestoreService: IObserveService
    
    private var messageRemovalServices: [Any] = []
    
    init(firestoreService: IObserveService, serviceAssembly: IServicesAssembly, coreDataStack: ICoreDataStack) {
        self.channelsFirestoreService = firestoreService
        self.serviceAssembly = serviceAssembly
        self.coreDataStack = coreDataStack
    }
            
    /// Create subscription to channel list updates
    func subscribeOnChannelsUpdates(handler: @escaping (Result<Bool, Error>) -> Void) {
       
        channelsFirestoreService.subscribeOnListUpdate { [weak self] (result: Result<[Channel], Error>, fetchCount) in
            guard let self = self else {
                return
            }
            switch result {
            
            case .success(let channels):
                if fetchCount == 1 {
                    self.deleteAllChannelsFromDB()
                }
                DispatchQueue.global(qos: .default).async {
                    self.coreDataStack.performSave { context in
                        self.logger?.info("Success update channels fetch: \(channels.count)")
                        channels.forEach { channel in
                            switch channel.diffType {
                            case .added, .modified:
                                _ = ChannelDB(channel: channel, in: context)
                            case .removed:
                                let id = channel.identifier
                                if let result = try? context.fetch(ChannelDB.fetchRequest(withId: id)).first {
                                    context.delete(result)
                                }
                            }
                        }
                        handler(.success(true))
                    }
                }
            case .failure(let error):
                self.logger?.error("Error fetching channels: \(error.localizedDescription)")
                handler(.failure(error))
            }
        }
    }
    
    /// Create a new channel in chanel list with given `name`
    func createChannel(name: String, handler: @escaping (Result<String, Error>) -> Void) {
        let newChannel = Channel(name: name)
        channelsFirestoreService.add(model: newChannel) { (result) in
            switch result {
            case .success(let id):
                handler(.success(id))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    /// Remove channel
    func deleteChannel(with id: String, handler: @escaping (Result<Bool, Error>) -> Void ) {

        let messageService = serviceAssembly.messageService(channelId: id)
        messageRemovalServices.append(messageService)
        
        messageService.deleteAllMessages { [weak self] (error) in
            if let error = error {
                handler(.failure(error))
            } else {
                self?.channelsFirestoreService.delete(modelWithId: id) { (error) in
                    if let error = error {
                        handler(.failure(error))
                    } else {
                        handler(.success(true))
                    }
                }
            }
        }
    }
         
    private func deleteAllChannelsFromDB() {
        DispatchQueue.main.async {
            self.coreDataStack.performSave { (context) in
                if let result = try? context.fetch(ChannelDB.fetchRequest()) as? [ChannelDB] {
                    result.forEach {
                        context.delete($0)
                    }
                }
            }
        }
    }
    
    private func deleteAllMessageFromDB(channelId: String) {
        DispatchQueue.main.async {
            self.coreDataStack.performSave { (context) in
                if let result = try? context.fetch(MessageDB.fetchRequest(forChannelId: channelId)) {
                    result.forEach {
                        context.delete($0)
                    }
                }
            }
        }
    }
    
}
