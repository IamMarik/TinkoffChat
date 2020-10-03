//
//  ThemeManager.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 03.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation


class ThemeManager {

    static let shared = ThemeManager()
    
    private(set) var themeOption: ThemeOptions = .classic {
        didSet {
            theme = themeOption.theme
        }
    }
    
    private(set) var theme: ApplicationTheme
    
    private var themeStoreKey = "application_theme"
  

    private init() {
        let themeOption: ThemeOptions
        if let storedKey = UserDefaults.standard.string(forKey: themeStoreKey) {
            themeOption = ThemeOptions(storedKey: storedKey)
        } else {
            themeOption = .classic
        }
        self.themeOption = themeOption
        self.theme = themeOption.theme
    }
    
    func setApplicationTheme(_ themeOption: ThemeOptions) {
        UserDefaults.standard.set(themeOption.rawValue, forKey: themeStoreKey)
        self.themeOption = themeOption
    }
    
}
