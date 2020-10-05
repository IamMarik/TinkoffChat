//
//  Theme.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 02.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit


protocol ApplicationTheme {
    
    var name: String { get }
    
    var statusBarStyle: UIStatusBarStyle { get }
    
    var colors: ThemeColors { get }
    
}

struct ThemeColors {
    let primaryBackground: UIColor
    let navigationBar: NavigationBarThemeColors
    let conversationList: ConversationListThemeColors
    let conversation: ConversationThemeColors
    let profile: ProfileThemeColors
}

struct NavigationBarThemeColors {
    let background: UIColor
    let title: UIColor
    let tint: UIColor
}

struct ConversationListThemeColors {
    
    let table: TableTheme
    
    let cell: CellTheme
    
    struct TableTheme {
        let sectionHeaderBackground: UIColor
        let sectionHeaderTitle: UIColor
    }
    
    struct CellTheme {
        let name: UIColor
        let message: UIColor
        let receivedDate: UIColor
        let cellSelected: UIColor
    }
}

struct ConversationThemeColors {
    
    let cell: CellTheme
    
    struct CellTheme {
        let incoming: MessageTheme
        let outgoing: MessageTheme
        
    }
    
    struct MessageTheme {
        let background: UIColor
        let text: UIColor
    }
}

struct ProfileThemeColors {
    let name: UIColor
    let description: UIColor
    let saveButtonBackground: UIColor
    let actionSheet: ActionSheetColors
}

struct ActionSheetColors {
    let background: UIColor
    let text: UIColor
}
