//
//  NightTheme.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 05.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

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
                separator: .black,
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
                incoming: .init(
                    background: UIColor(hex: 0x2E2E2E),
                    text: .white),
                outgoing: .init(
                    background: UIColor(hex: 0x5C5C5C),
                    text: .white
                )
            ),
            bottomViewBackground: .black,
            input: .init(
                background: UIColor(hex: 0x3B3B3B),
                text: .white
            )           
        ),
        profile: .init(
            name: .white,
            description: .white,
            saveButtonBackground: UIColor(hex: 0x1B1B1B),
            actionSheet: .init(
                background: UIColor(hex: 0x1B1B1B),
                text: .white
            ),
            loadingViewBackground: UIColor(hex: 0x1B1B1B)
        ),
        settings: .init(
            background: UIColor(hex: 0x2D3047)
        )
    )
   
}
