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
       
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCallMethods() throws {
        let mockProfile = ProfileViewModel(fullName: "foo", description: "baz", avatar: nil)
        let mockProfileDataManager = MockProfileDataManager(mockProfile: mockProfile)
        let userDataStore = UserDataStore(profileDataManager: mockProfileDataManager)
        
        userDataStore.loadProfile { (profile) in
            assert(mockProfile == profile, "Profiles should be the same")
        }
        
        assert(mockProfileDataManager.readProfileFromDiskCount == 1, "ReadProfileFromDisk should be called exact 1 time")
        
        userDataStore.saveProfile(profile: mockProfile) { _ in }
      
        assert(mockProfileDataManager.writeToDiskCount == 1, "writeToDisk should be called exact 1 time")
    }

}

extension ProfileViewModel: Equatable {
    
    public static func == (lhs: ProfileViewModel, rhs: ProfileViewModel) -> Bool {
        return lhs.fullName == rhs.fullName && lhs.description == rhs.description && lhs.avatar === rhs.avatar
    }
}
