//
//  ThemeManager.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 03.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation


struct Themes {
    
    static private(set) var current: ApplicationTheme = ThemeOptions.classic.theme
    
    static private(set) var currentThemeOption: ThemeOptions = .classic {
        didSet {
            current = currentThemeOption.theme
        }
    }
        
    private static let themeStoreKey = "application_theme"
    
    static func loadApplicationTheme() {
        let themeOption: ThemeOptions
        if let storedKey = UserDefaults.standard.string(forKey: themeStoreKey) {
            themeOption = ThemeOptions(storedKey: storedKey)
        } else {
            themeOption = .classic
        }
        Self.currentThemeOption = themeOption
    }
    
    static func saveApplicationTheme(_ themeOption: ThemeOptions) {
        UserDefaults.standard.set(themeOption.rawValue, forKey: themeStoreKey)
        Self.currentThemeOption = themeOption
    }
    
}

enum ThemeOptions: String, CaseIterable {
    
    case classic
    case day
    case night
    
    var theme: ApplicationTheme {
        switch self {
        case .classic:
            return ClassicTheme()
        case .day:
            return DayTheme()
        case .night:
            return NightTheme()
        }
    }
    
    init(storedKey: String) {
        self = ThemeOptions.init(rawValue: storedKey) ?? .classic
    }
        
}
