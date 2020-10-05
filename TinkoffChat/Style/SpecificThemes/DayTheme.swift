//
//  DayTheme.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 05.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit


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
                cellSelected: .white
            )
        ),
        conversation: .init(
            cell: .init(
                incoming: .init(
                    background: UIColor(hex: 0xEAEBED),
                    text: .black),
                outgoing: .init(
                    background: UIColor(hex: 0x4389F9),
                    text: .white
                )
            )
        ),
        profile: .init(
            name: .black,
            description: .black,
            saveButtonBackground: UIColor(hex: 0xF6F6F6),
            actionSheet: .init(
                background: .white,
                text: .darkGray
            )
        )
    )
    
}
