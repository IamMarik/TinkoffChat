//
//  ConfigurableView.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 26.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation


protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
    
}
