//
//  RootNavigationController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 03.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return viewControllers.first
    }

}
