//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 10.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import UIKit

protocol IPresenentationAssembly {
    
    func rootNavigationViewController() -> RootNavigationController
    
    //func conversationListViewController() -> ConversationsListViewController
    
    func conversationViewController(channelId: String) -> ConversationViewController
    
    func profileViewController() -> ProfileViewController
    
    func settingsViewController() -> ThemesViewController
    
}

class PresenentationAssembly: IPresenentationAssembly {
    
    let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func rootNavigationViewController() -> RootNavigationController {
        guard let rootNavigationController = UIStoryboard(name: "Conversations", bundle: nil).instantiateInitialViewController() as? RootNavigationController else {
            fatalError("Can't instantiate RootNavigationController")
        }
        guard let conversationListViewController = rootNavigationController.topViewController as? ConversationsListViewController else {
            fatalError("Top view controller of RootNavigationController is not ConversationListViewController")
        }
        conversationListViewController.channelsService = serviceAssembly.channelsService()
        conversationListViewController.logger = serviceAssembly.logger(for: conversationListViewController)
        conversationListViewController.userDataStore = serviceAssembly.userDataStore
        conversationListViewController.presentationAssembly = self
        return rootNavigationController
    }
        
    func conversationViewController(channelId: String) -> ConversationViewController {
        guard let conversationViewController = UIStoryboard(name: "Conversation", bundle: nil).instantiateInitialViewController() as? ConversationViewController else {
            fatalError("Can't instantiate ConversationViewController")
        }
        conversationViewController.channelId = channelId
        conversationViewController.messageService = serviceAssembly.messageService(channelId: channelId)
        return conversationViewController
    }
    
    func profileViewController() -> ProfileViewController {
        guard let profileViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profileId") as? ProfileViewController else {
            fatalError("Can't instantiate ConversationViewController")
        }
        profileViewController.userDataStore = serviceAssembly.userDataStore
        return profileViewController
    }
    
    func settingsViewController() -> ThemesViewController {
        guard let settingsViewController = UIStoryboard(name: "ThemeSettings", bundle: nil).instantiateViewController(withIdentifier: "ThemeSettingsId") as? ThemesViewController else {
            fatalError("Can't instantiate ConversationViewController")
        }
        return settingsViewController
    }
    
}
