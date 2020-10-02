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
    
    var colors: ThemeColors { get }
      
}

struct ThemeColors {
    let background: UIColor
    let imcomingMessage: UIColor
    let outgoingMessage: UIColor    
}

struct ClassicTheme: ApplicationTheme {
    
    var name = "Classic"
    
    var colors = ThemeColors(
        background: .white,
        imcomingMessage: UIColor(hex: 0xDFDFDF),
        outgoingMessage: UIColor(hex: 0xDCF7C5)
    )
}

struct DayTheme: ApplicationTheme {
    
    var name = "Day"
    
    var colors = ThemeColors(
        background: .white,
        imcomingMessage: UIColor(hex: 0xEAEBED),
        outgoingMessage: UIColor(hex: 0x4389F9)
    )
   
}


struct NightTheme: ApplicationTheme {
    
    var name = "Night"
    
    var colors = ThemeColors(
        background: UIColor(hex: 0x060606),
        imcomingMessage: UIColor(hex: 0x2E2E2E),
        outgoingMessage: UIColor(hex: 0x5C5C5C)
    )
    
}
