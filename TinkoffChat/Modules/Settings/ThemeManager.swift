//
//  ThemeManager.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 03.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation


class ThemeManager: ThemesPickerDelegate {

    
    
    static let shared = ThemeManager()
    
    var theme: ApplicationTheme {
        themeOption.theme
    }
    
    private var themeOption: ThemeOptions = .classic
    
    private init() { }
    
    func themeDidChanged(_ viewController: ConversationsListViewController, on themeOption: ThemeOptions) {
        self.themeOption = themeOption
        
    }
    
    func themeDidChanged(on themeOption: ThemeOptions) {
        self.themeOption = themeOption
    }
    
}
