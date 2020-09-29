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
            ConversationCellModel(name: "Jimmie Jacobs",
                                  message: "Lorem ipsum et cetera",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: true,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Siddharth Heal",
                                  message: "",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: true,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Avleen Bird",
                                  message: "Lorem ipsum et cetera",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: true,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Ravena Martinez",
                                  message: "You are read it",
                                  date: Date(),
                                  isOnline: true,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Zhane Flowers",
                                  message: "Please call me later",
                                  date: Date(),
                                  isOnline: true,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Viola Philip",
                                  message: "Lorem ipsum et cetera",
                                  date: dateFormatter.dateOrNow(from: "21092020"),
                                  isOnline: true,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Britney Truong",
                                  message: "",
                                  date: dateFormatter.dateOrNow(from: "20092020"),
                                  isOnline: true,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Matthias Hartley",
                                  message: "Lorem ipsum et cetera",
                                  date: dateFormatter.dateOrNow(from: "19092020"),
                                  isOnline: true,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Piper Ramsay",
                                  message: "You are read it",
                                  date: Date(),
                                  isOnline: true,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Darci Santana",
                                  message: "Please call me later",
                                  date: Date(),
                                  isOnline: true,
                                  hasUnreadMessage: true),
        ]
        
        var historySection = ConversationSection(title: "History")
        historySection.conversations = [
            ConversationCellModel(name: "Jimmie Jacobs",
                                  message: "Lorem ipsum et cetera",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: false,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Siddharth Heal",
                                  message: "",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: false,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Avleen Bird",
                                  message: "Lorem ipsum et cetera",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: false,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Ravena Martinez",
                                  message: "You are read it",
                                  date: Date(),
                                  isOnline: false,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Zhane Flowers",
                                  message: "Please call me later",
                                  date: Date(),
                                  isOnline: false,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Viola Philip",
                                  message: "Lorem ipsum et cetera",
                                  date: dateFormatter.dateOrNow(from: "21092020"),
                                  isOnline: false,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Britney Truong",
                                  message: "",
                                  date: dateFormatter.dateOrNow(from: "20092020"),
                                  isOnline: false,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Matthias Hartley",
                                  message: "Lorem ipsum et cetera",
                                  date: dateFormatter.dateOrNow(from: "19092020"),
                                  isOnline: false,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Piper Ramsay",
                                  message: "You are read it",
                                  date: Date(),
                                  isOnline: false,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Darci Santana",
                                  message: "Please call me later",
                                  date: Date(),
                                  isOnline: false,
                                  hasUnreadMessage: true),
        ]
        
        return [onlineSection, historySection]
    }()
    
    
}
