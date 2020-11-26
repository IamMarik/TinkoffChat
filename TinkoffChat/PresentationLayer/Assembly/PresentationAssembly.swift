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
    
    func rootNavigationViewController(_ rootViewController: UIViewController?) -> RootNavigationController
    
    func conversationListViewController() -> ConversationsListViewController
    
    func conversationViewController(channelId: String) -> ConversationViewController
    
    func profileViewController() -> ProfileViewController
    
    func settingsViewController() -> ThemesViewController
    
    func networkImagePickerViewController(delegate: ImagePickerViewControllerDelegate?) -> ImagePickerViewController
    
}

class PresenentationAssembly: IPresenentationAssembly {
    
    let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func rootNavigationViewController(_ rootViewController: UIViewController?) -> RootNavigationController {
        if let rootVC = rootViewController {
           return RootNavigationController(rootViewController: rootVC)
        } else {
            return RootNavigationController()
        }
    }
    
    func conversationListViewController() -> ConversationsListViewController {
        guard let conversationListViewController = UIStoryboard(name: "Conversations", bundle: nil)
                .instantiateViewController(withIdentifier: "ConversationListId") as? ConversationsListViewController else {
            fatalError("Can't instantiate ConversationListViewController")
        }
        conversationListViewController.channelsService = serviceAssembly.channelsService()
        conversationListViewController.logger = serviceAssembly.logger(for: conversationListViewController)
        conversationListViewController.userDataStore = serviceAssembly.userDataStore
        conversationListViewController.fetchedResultsController = serviceAssembly.channelsFetchResultsController()
        conversationListViewController.presentationAssembly = self
        return conversationListViewController
    }
        
    func conversationViewController(channelId: String) -> ConversationViewController {
        guard let conversationViewController = UIStoryboard(name: "Conversation", bundle: nil).instantiateInitialViewController() as? ConversationViewController else {
            fatalError("Can't instantiate ConversationViewController")
        }
        conversationViewController.channelId = channelId
        conversationViewController.messageService = serviceAssembly.messageService(channelId: channelId)
        conversationViewController.fetchedResultsController = serviceAssembly.messagesFetchResultsController(channelId: channelId)
        conversationViewController.logger = serviceAssembly.logger(for: conversationViewController)
        return conversationViewController
    }
    
    func profileViewController() -> ProfileViewController {
        guard let profileViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profileId") as? ProfileViewController else {
            fatalError("Can't instantiate ConversationViewController")
        }
        profileViewController.userDataStore = serviceAssembly.userDataStore
        profileViewController.presentationAssembly = self
        return profileViewController
    }
    
    func settingsViewController() -> ThemesViewController {
        guard let settingsViewController = UIStoryboard(name: "ThemeSettings", bundle: nil)
                .instantiateViewController(withIdentifier: "ThemeSettingsId") as? ThemesViewController else {
            fatalError("Can't instantiate ConversationViewController")
        }
        return settingsViewController
    }
    
    func networkImagePickerViewController(delegate: ImagePickerViewControllerDelegate?) -> ImagePickerViewController {
        guard let imagePickerViewController = UIStoryboard(name: "ImagePicker", bundle: nil)
                .instantiateViewController(withIdentifier: "AvatarListId") as? ImagePickerViewController else {
            fatalError("Can't instantiate NetworkImagePickerViewController")
        }
        imagePickerViewController.avatarService = serviceAssembly.avatarService()
        imagePickerViewController.delegate = delegate
        return imagePickerViewController
    }
    
}
