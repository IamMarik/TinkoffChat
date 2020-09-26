//
//  ConversationSectionsMockData.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 26.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation


class ConversationSectionsMockData {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter
    }()
    
    static var sections: [ConversationSection] = {
        var onlineSection = ConversationSection(title: "Online")
        
        onlineSection.conversations = [
            ConversationCellModel(name: "First Name",
                                  message: "Lorem ipsum et cetera",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: true,
                                  hasUnreadMessage: true)
        ]
        
        var historySection = ConversationSection(title: "History")
        return [onlineSection, historySection]
    }()
    
    
}
