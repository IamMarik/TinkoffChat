//
//  MockProfileService.swift
//  TinkoffChatTests
//
//  Created by Марат Джаныбаев on 30.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
@testable import TinkoffChat

class MockProfileDataManager: IProfileDataManager {
    
    var writeToDiskCount = 0
    var readProfileFromDiskCount = 0
    var passingNewProfile: ProfileViewModel?
    var passingOldProfile: ProfileViewModel?
    
    private let mockProfile: ProfileViewModel
    
    init(mockProfile: ProfileViewModel) {
        self.mockProfile = mockProfile
    }
    
    func writeToDisk(newProfile: ProfileViewModel, oldProfile: ProfileViewModel?, completion: @escaping ((Bool) -> Void)) {
        writeToDiskCount += 1
        passingNewProfile = newProfile
        passingOldProfile = oldProfile
        completion(true)
    }
    
    func readProfileFromDisk(completion: @escaping ((ProfileViewModel?) -> Void)) {
        readProfileFromDiskCount += 1
        completion(mockProfile)
    }

}
