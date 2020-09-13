//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Marik on 12.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        Log.d("Application moved from Non Running to Inactive: \(#function)")
        Log.d("Current state: \(application.applicationState.description)")
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Log.d("Application will be moved from Inactive to Active: \(#function)")
        Log.d("Current state: \(application.applicationState.description)")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Log.d("Application will be moved from Active to Inactive: \(#function)")
        Log.d("Current state: \(application.applicationState.description)")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Log.d("Application moved from Inactive to Active: \(#function)")
        Log.d("Current state: \(application.applicationState.description)")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Log.d("Application will be moved from Background to Inactive \(#function)")
        Log.d("Current state: \(application.applicationState.description)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Log.d("Application moved from Inactive to Background: \(#function)")
        Log.d("Current state: \(application.applicationState.description)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Log.d("Application will be moved from \(application.applicationState.description) to Non running: \(#function)")
        Log.d("Current state: \(application.applicationState.description)")
    }

}



