//
//  ThemeManager.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 03.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

/**
    Изначально писался ThemesManager. Но доставание текущей темы выглядело не лаконично,
    поэтому было решено сделать доступ к конкретной теме через статичное поле.
 */
struct Themes {
    
    static private(set) var current: ApplicationTheme = ThemeOptions.classic.theme
    
    /// Заприватил поля чтобы исключить проблемы с shared state
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
        currentThemeOption = themeOption
    }
    
    static func saveApplicationTheme(_ themeOption: ThemeOptions) {
        UserDefaults.standard.set(themeOption.rawValue, forKey: themeStoreKey)
        currentThemeOption = themeOption
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
