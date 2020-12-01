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
                assert(id == "foo")
            } else {
                assertionFailure()
            }
        }
        
        assert(mockFirestoreService.addCount == 1)
        assert(mockCoreDataStack.performSaveCount == 0)
        assert(mockUserDataStore.getIdentifierCount == 1)
    }
    
    func testAddMessageError() throws {
        mockFirestoreService.addReturnId = "foo"
        mockFirestoreService.addError = mockError
        messageService.addMessage(content: "test") { (result) in
            if case let .failure(error) = result {
                assert((error as NSError) === mockError)
            } else {
                assertionFailure()
            }
        }
        
        assert(mockFirestoreService.addCount == 1)
        assert(mockCoreDataStack.performSaveCount == 0)
        assert(mockUserDataStore.getIdentifierCount == 1)
    }
    
    func testSubscribe() throws {
        let testChannelId = "123456"
        let service = MessageService(channelId: testChannelId,
                                     firestoreService: mockFirestoreService,
                                     userDataStore: mockUserDataStore,
                                     coreDataStack: mockCoreDataStack)
        
    }
    
}
