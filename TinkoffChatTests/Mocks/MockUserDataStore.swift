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
    
    let identifier: String = "test_id"
    
    var profile: ProfileViewModel? = {
        let profile = ProfileViewModel(fullName: "Test Name", description: "Test Description", avatar: nil)
        return profile
    }()
    
    func saveProfile(profile: ProfileViewModel, completion: @escaping (Bool) -> Void) {
        saveProfileCount += 1
    }
    
    func loadProfile(completion: @escaping (ProfileViewModel) -> Void) {
        loadProfileCount += 1
    }
}
