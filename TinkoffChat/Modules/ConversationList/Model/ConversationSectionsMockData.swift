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
                                  message: "Hey, what's up?",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: true,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Siddharth Heal",
                                  message: "",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: true,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Avleen Bird",
                                  message: "Wanna eat?",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: true,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Ravena Martinez",
                                  message: "You have read it",
                                  date: Date.randomTimePastToday(),
                                  isOnline: true,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Zhane Flowers",
                                  message: "Please call me later",
                                  date: Date.randomTimePastToday(),
                                  isOnline: true,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Viola Philip",
                                  message: "What the heck? Just watch this: Second line will be here, and nothing more. Even if we added a little bit more text",
                                  date: dateFormatter.dateOrNow(from: "21092020"),
                                  isOnline: true,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Britney Truong",
                                  message: "",
                                  date: dateFormatter.dateOrNow(from: "20092020"),
                                  isOnline: true,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Matthias Hartley",
                                  message: "",
                                  date: dateFormatter.dateOrNow(from: "19092020"),
                                  isOnline: true,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Piper Ramsay",
                                  message: "You are read it",
                                  date: Date.randomTimePastToday(),
                                  isOnline: true,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Darci Santana",
                                  message: "Please call me later",
                                  date: Date.randomTimePastToday(),
                                  isOnline: true,
                                  hasUnreadMessage: true)
        ]
        
        var historySection = ConversationSection(title: "History")
        historySection.conversations = [
            ConversationCellModel(name: "Ashleigh Atkinson",
                                  message: "😁",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: false,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Oisin Dodd",
                                  message: "",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: false,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Connie Richard",
                                  message: "Lol😊",
                                  date: dateFormatter.dateOrNow(from: "22092020"),
                                  isOnline: false,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Uma Stokes",
                                  message: "So what?",
                                  date: Date.randomTimePastToday(),
                                  isOnline: false,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Macie Fitzgerald",
                                  message: "Aaaaaaand?🧐",
                                  date: Date.randomTimePastToday(),
                                  isOnline: false,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Ayrton Decker",
                                  message: "No No No",
                                  date: dateFormatter.dateOrNow(from: "21092020"),
                                  isOnline: false,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Stan Jones",
                                  message: "",
                                  date: dateFormatter.dateOrNow(from: "20092020"),
                                  isOnline: false,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Arman Mansell",
                                  message: "Hello, it's me",
                                  date: dateFormatter.dateOrNow(from: "19092020"),
                                  isOnline: false,
                                  hasUnreadMessage: true),
            ConversationCellModel(name: "Drew Lugo",
                                  message: "I was wondering if after all these years you'd like to meet",
                                  date: Date.randomTimePastToday(),
                                  isOnline: false,
                                  hasUnreadMessage: false),
            ConversationCellModel(name: "Rabia Stuart",
                                  message: "To go over everything\nThey say that time'ssupposed to heal ya But I ain't done much healing",
                                  date: Date.randomTimePastToday(),
                                  isOnline: false,
                                  hasUnreadMessage: true)
        ]
        
        return [onlineSection, historySection]
    }()
    
}
