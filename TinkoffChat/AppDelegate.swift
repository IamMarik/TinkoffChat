//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Dzhanybaev Marat on 12.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Themes.loadApplicationTheme()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let conversationsViewController = rootAssembly.presentationAssembly.conversationListViewController()
        let rootNavigationController = rootAssembly.presentationAssembly
            .rootNavigationViewController(conversationsViewController)
        window?.rootViewController = rootNavigationController
        window?.emitEmblemOnTouch()
//        let avatarListViewController = rootAssembly.presentationAssembly.avatarListViewController()
//        window?.rootViewController = avatarListViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
