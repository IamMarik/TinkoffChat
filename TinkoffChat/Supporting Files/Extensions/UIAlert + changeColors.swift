//
//  UIAlert + changeColors.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 14.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func set(backgroundColor: UIColor) {
        let contentView = view.subviews.first?.subviews.first?.subviews.first
        contentView?.backgroundColor = backgroundColor
    }
    
    func set(title: String?, font: UIFont = UIFont.systemFont(ofSize: 17), color: UIColor) {
        guard let title = title else { return }
        let attributedTitle = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ])
        setValue(attributedTitle, forKey: "attributedTitle")
    }
    
    func set(message: String?, font: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular), color: UIColor) {
        guard let message = message else { return }
        let attributedMessage = NSAttributedString(string: message, attributes: [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ])
        setValue(attributedMessage, forKey: "attributedMessage")
    }
    
}
