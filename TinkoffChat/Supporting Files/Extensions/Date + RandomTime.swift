//
//  Date + RandomTime.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 30.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

extension Date {
        
    static func randomTimePastToday() -> Date {
        let now = Date()
        let calendar = Calendar.current
        let beginOfDay = calendar.startOfDay(for: Date())
        let randomMillis = Double.random(in: beginOfDay.timeIntervalSince1970 ..< now.timeIntervalSince1970)
        return Date(timeIntervalSince1970: randomMillis)
    }
    
}
