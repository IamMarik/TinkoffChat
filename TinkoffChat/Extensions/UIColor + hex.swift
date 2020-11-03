//
//  UIColor + hex.swift
//  TinkoffChat
//
//  Created by Marik on 21.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

extension UIColor {

   convenience init(red: Int, green: Int, blue: Int) {
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
   }
}
