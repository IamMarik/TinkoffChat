//
//  MessageServiceTests.swift
//  TinkoffChatTests
//
//  Created by Марат Джаныбаев on 29.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import XCTest
@testable import TinkoffChat

class MessageServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        let mockCoreDataStack = MockCoreDataStack()
        let mockUserDataStore = MockUserDataStore()
        let testChannelId = "123456"
        let service = MessageService(channelId: testChannelId, userDataStore: mockUserDataStore, coreDataStack: mockCoreDataStack)
        
        service.addMessage(content: "test") { (_) in
            
        }
    
    }

}
