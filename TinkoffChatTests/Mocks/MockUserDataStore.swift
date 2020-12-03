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
    var savingProfile: ProfileViewModel?
    
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
        savingProfile = profile
        saveProfileCount += 1
        completion(true)
    }
    
    func loadProfile(completion: @escaping (ProfileViewModel) -> Void) {
        loadProfileCount += 1
        completion(profile ?? ProfileViewModel(fullName: "", description: "", avatar: nil))
    }
}
