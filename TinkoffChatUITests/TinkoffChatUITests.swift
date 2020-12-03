//
//  TinkoffChatUITests.swift
//  TinkoffChatUITests
//
//  Created by Марат Джаныбаев on 29.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import XCTest

class TinkoffChatUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testProfile() throws {
     
        let app = XCUIApplication()
        app.launch()
        sleep(3)
        let profileButton = app.buttons["profileBarButton"].firstMatch
        XCTAssert(profileButton.waitForExistence(timeout: 1))
        profileButton.tap()
        sleep(2)
        let editButton = app.buttons["profileEditButton"].firstMatch
        XCTAssert(profileButton.waitForExistence(timeout: 1))
        editButton.tap()
        let nameTextField = app.textFields["profileNameTextField"].firstMatch
        XCTAssert(nameTextField.waitForExistence(timeout: 1))
        let descriptionTextView = app.textViews["profileDescriptionTextView"].firstMatch
        XCTAssert(descriptionTextView.waitForExistence(timeout: 1))
    }

}
