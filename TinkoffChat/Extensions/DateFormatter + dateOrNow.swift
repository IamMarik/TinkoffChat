//
//  DateOrNow.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 26.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    func dateOrNow(from string: String) -> Date {
        return self.date(from: string) ?? Date()
    }
}
