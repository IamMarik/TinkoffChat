//
//  UIApplication.State + title.swift
//  TinkoffChat
//
//  Created by Marik on 12.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

extension UIApplication.State {

    var description: String {
        switch self {
        case .active:
            return "Active"
        case .inactive:
            return "Inactive"
        case .background:
            return "Background"
        @unknown default:
            return "Unknown"
        }
    }
}
