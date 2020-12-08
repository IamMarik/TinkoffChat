//
//  UserServiceDataStoreTest.swift
//  TinkoffChatTests
//
//  Created by Марат Джаныбаев on 30.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import XCTest
@testable import TinkoffChat

class UserServiceDataStoreTest: XCTestCase {
       
    func testCallMethods() throws {
        let mockProfile = ProfileViewModel(fullName: "foo", description: "baz", avatar: nil)
        let mockProfileDataManager = MockProfileDataManager(mockProfile: mockProfile)
        let userDataStore = UserDataStore(profileDataManager: mockProfileDataManager)
        let newProfile = ProfileViewModel(fullName: "newfoo", description: "newbaz", avatar: nil)
        userDataStore.loadProfile { (profile) in
            XCTAssert(mockProfile == profile, "Profiles should be the same")
        }
        
        XCTAssert(mockProfileDataManager.readProfileFromDiskCount == 1, "ReadProfileFromDisk should be called exact 1 time")
        
        userDataStore.saveProfile(profile: newProfile) { _ in }
        
        XCTAssert(mockProfileDataManager.passingOldProfile == mockProfile)
        XCTAssert(mockProfileDataManager.passingNewProfile == newProfile)
      
        XCTAssert(mockProfileDataManager.writeToDiskCount == 1, "writeToDisk should be called exact 1 time")
    }

}

extension ProfileViewModel: Equatable {
    
    public static func == (lhs: ProfileViewModel, rhs: ProfileViewModel) -> Bool {
        return lhs.fullName == rhs.fullName && lhs.description == rhs.description && lhs.avatar === rhs.avatar
    }
}
