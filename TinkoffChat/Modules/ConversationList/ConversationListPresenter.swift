//
//  ConversationListPresenter.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 04.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

class ConversationListPresenter {
    
    weak var view: ConversationListView?
        
    var service: ChannelsService?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "lastActivity", ascending: false)
        let sortById = NSSortDescriptor(key: "identifier", ascending: true)
        request.sortDescriptors = [sortByDate, sortById]
        request.fetchBatchSize = 10
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: CoreDataStack.shared.mainContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }()
    
    init(for view: ConversationListView) {
        self.view = view
    }
    
    func activate() {
        loadSavedData()
        service?.subscribeOnChannels(handler: { (result) in
            switch result {
            case .success(let channels):
                DispatchQueue.main.async {
                    self?.channels = channels
                    // По-хорошему можно обновлять с анимацией добавления, перемещения канала
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                Log.error("Error during update channels: \(error.localizedDescription)")
            }
        })
    }
    
    func createChannel(name: String) {
        service?.createChannel(name: name) { [weak view] (result) in
            if case Result.failure(_) = result {
                view?.showError(message: "Error during create new channel, try later.")
            }
        }
    }
    
    private func loadSavedData() {
        do {
            try fetchedResultsController.performFetch()
            guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
                view?.updateView(with: [])
                return
            }
            let channels = fetchedObjects.map { Channel(dbModel: $0) }
            view?.updateView(with: channels)
        } catch {
            view?.showError(message: "Fetch channels request failed")
            Log.error("Fetch channels request failed")
        }
    }
    
   
    
}

protocol ConversationListView: AnyObject {
    func updateView(with channels: [Channel])
    
    func showError(message: String)
}
