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
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        //CoreDataStack.shared.deleteStore()
        CoreDataStack.shared.addStatisticObserver()
        showingFetchRequestOnStart()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Themes.loadApplicationTheme()
        return true
    }
    
    private func showingFetchRequestOnStart() {
        let context = CoreDataStack.shared.mainContext
        // Логирую подтверждение того, что данные сохраняются при перезагрузке
        let resultChannels = (try? context.fetch(ChannelDB.fetchRequest()) as? [ChannelDB]) ?? []
        let resultMessages = (try? context.fetch(MessageDB.fetchRequest()) as? [MessageDB]) ?? []
        Log.info("Database contains \(resultChannels.count) channels and \(resultMessages.count) messages", tag: "DBState")
    }

}
