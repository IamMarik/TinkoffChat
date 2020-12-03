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
    
    var testChannelId: String!
    var mockCoreDataStack: MockCoreDataStack!
    var mockUserDataStore: MockUserDataStore!
    var mockFirestoreService: MockFirestoreService<Message>!
    var messageService: MessageService!
    
    override func setUpWithError() throws {
        testChannelId = "123456"
        mockCoreDataStack = MockCoreDataStack()
        mockUserDataStore = MockUserDataStore()
        mockFirestoreService = MockFirestoreService<Message>()
        messageService = MessageService(channelId: testChannelId,
                                        firestoreService: mockFirestoreService,
                                        userDataStore: mockUserDataStore,
                                        coreDataStack: mockCoreDataStack)
    }
    override func tearDownWithError() throws {
        mockCoreDataStack = nil
        mockUserDataStore = nil
        mockFirestoreService = nil
    }
    
    func testAddMessageSuccess() throws {
        mockFirestoreService.addReturnId = "foo"
        
        messageService.addMessage(content: "test") { (result) in
            if case let .success(id) = result {
                XCTAssert(id == "foo")
            } else {
                XCTFail("Message adding handler return error")
            }
        }
        
        XCTAssert(mockFirestoreService.addCount == 1)
        XCTAssert(mockCoreDataStack.performSaveCount == 0)
        XCTAssert(mockUserDataStore.getIdentifierCount == 1)
        let addedModel = mockFirestoreService.addModel
        XCTAssertNotNil(addedModel)
        let messageModel = addedModel as? Message
        XCTAssertNotNil(messageModel)
        XCTAssert(messageModel?.content == "test")
    }
    
    func testAddMessageError() throws {
        mockFirestoreService.addReturnId = "foo"
        mockFirestoreService.addError = mockError
        messageService.addMessage(content: "test") { (result) in
            if case let .failure(error) = result {
                XCTAssert((error as NSError) === mockError)
            } else {
                XCTFail("Result should be failure")
            }
        }
        
        XCTAssert(mockFirestoreService.addCount == 1)
        XCTAssert(mockCoreDataStack.performSaveCount == 0)
        XCTAssert(mockUserDataStore.getIdentifierCount == 1)
    }
        
}
