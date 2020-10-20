//
//  Alert.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 20.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func themeAlert(title: String?,
                           message: String?,
                           actions: [UIAlertAction]? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.set(title: title, color: Themes.current.colors.profile.actionSheet.text)
        alertController.set(message: message, color: Themes.current.colors.profile.actionSheet.text)
        alertController.set(backgroundColor: Themes.current.colors.profile.actionSheet.background)
        actions?.forEach { alertController.addAction($0) }
        return alertController
    }
    
}
