//
//  Theme.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 02.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit


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
        let imcomingMessageBackground: UIColor
        let outgoingMessageBackground: UIColor
    }
}

struct ProfileThemeColors {
    let name: UIColor
    let description: UIColor
    let saveButtonBackground: UIColor
}



// MARK: Themes implementations
struct ClassicTheme: ApplicationTheme {
    
    var name = "Classic"
    
    var statusBarStyle: UIStatusBarStyle { .default }
        
    var colors = ThemeColors(
        primaryBackground: .white,
        navigationBar: .init(
            background: UIColor(hex: 0xF5F5F5),
            title: .black,
            tint:  UIColor(hex: 0x545458)
        ),
        conversationList: .init(
            table: .init(
                sectionHeaderBackground: .lightGray,
                sectionHeaderTitle: .black
            ),
            cell: .init(
                name: .black,
                message: UIColor(hex: 0x3C3C43).withAlphaComponent(0.6),
                receivedDate: UIColor(hex: 0x3C3C43).withAlphaComponent(0.6),
                cellSelected: .lightGray
            )
        ),
        conversation: .init(
            cell: .init(
                imcomingMessageBackground: UIColor(hex: 0xDFDFDF),
                outgoingMessageBackground: UIColor(hex: 0xDCF7C5)
            )
        ),
        profile: .init(
            name: .black,
            description: .black,
            saveButtonBackground: UIColor(hex: 0xF6F6F6)
        )
    )
    
}

struct DayTheme: ApplicationTheme {
    
    var name = "Day"
    
    var statusBarStyle: UIStatusBarStyle { .default }
    
    var colors = ThemeColors(
        primaryBackground: .white,
        navigationBar: .init(
            background: UIColor(hex: 0xF5F5F5),
            title: .black,
            tint:  UIColor(hex: 0x545458)
        ),
        conversationList: .init(
            table: .init(
                sectionHeaderBackground: .lightGray,
                sectionHeaderTitle: .black
            ),
            cell: .init(
                name: .black,
                message: UIColor(hex: 0x3C3C43).withAlphaComponent(0.6),
                receivedDate: UIColor(hex: 0x3C3C43).withAlphaComponent(0.6),
                cellSelected: .lightGray
            )
        ),
        conversation: .init(
            cell: .init(
                imcomingMessageBackground: UIColor(hex: 0xEAEBED),
                outgoingMessageBackground: UIColor(hex: 0x4389F9)
            )
        ),
        profile: .init(
            name: .black,
            description: .black,
            saveButtonBackground: UIColor(hex: 0xF6F6F6)
        )
    )
    
   
}


struct NightTheme: ApplicationTheme {
    
    var name = "Night"
    
    var statusBarStyle: UIStatusBarStyle { .lightContent }
    
    var colors = ThemeColors(
        primaryBackground: UIColor(hex: 0x060606),
        navigationBar: .init(
            background: UIColor(hex: 0x1E1E1E),
            title: .white,
            tint:  .white
        ),
        conversationList: .init(
            table: .init(
                sectionHeaderBackground: .darkGray,
                sectionHeaderTitle: .white
            ),
            cell: .init(
                name: .white,
                message: UIColor(hex: 0x8D8D93),
                receivedDate: UIColor(hex: 0x8D8D93),
                cellSelected: .darkGray
            )
        ),
        conversation: .init(
            cell: .init(
                imcomingMessageBackground: UIColor(hex: 0x2E2E2E),
                outgoingMessageBackground: UIColor(hex: 0x5C5C5C)
            )
        ),
        profile: .init(
            name: .white,
            description: .white,
            saveButtonBackground: UIColor(hex: 0x1B1B1B)
        )
    )
    
    
}
