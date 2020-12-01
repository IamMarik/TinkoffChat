//
//  MockUserDataStore.swift
//  TinkoffChatTests
//
//  Created by Марат Джаныбаев on 29.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
@testable import TinkoffChat

final class MockUserDataStore: IUserDataStore {
    
    var saveProfileCount = 0
    var loadProfileCount = 0
    var getIdentifierCount = 0
    var getProfileCount = 0
    
    var idetifierReturn = "testId"
    
    var profileReturn = ProfileViewModel(fullName: "Test Name", description: "Test Description", avatar: nil)
    
    var identifier: String {
        getIdentifierCount += 1
        return idetifierReturn
    }
    
    var profile: ProfileViewModel? {
        getProfileCount += 1
        return profileReturn
    }
    
    func saveProfile(profile: ProfileViewModel, completion: @escaping (Bool) -> Void) {
        saveProfileCount += 1
    }
    
    func loadProfile(completion: @escaping (ProfileViewModel) -> Void) {
        loadProfileCount += 1
    }
}
