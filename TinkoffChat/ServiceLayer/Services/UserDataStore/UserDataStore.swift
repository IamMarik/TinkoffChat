//
//  UserData.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 18.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol IUserDataStore {
    var identifier: String { get }
    var profile: ProfileViewModel? { get }
    func saveProfile(profile: ProfileViewModel, completion: @escaping (Bool) -> Void)
    func loadProfile(completion: @escaping (ProfileViewModel) -> Void)
}

class UserDataStore: IUserDataStore {
    
    static var shared: IUserDataStore = UserDataStore()
    
    let profileDataManager: IProfileDataManager
    
    init(profileDataManager: IProfileDataManager = GCDProfileDataManager()) {
        self.profileDataManager = profileDataManager
    }
    
    private static var keyIdentifier = "user_identifier"
    
    private var _identifier: String?
    
    var identifier: String {
        if let id = _identifier {
            return id
        } else if let id = UserDefaults.standard.string(forKey: Self.keyIdentifier) {
            _identifier = id
            return id
        } else {
            let id = UUID().uuidString
            UserDefaults.standard.setValue(id, forKey: Self.keyIdentifier)
            _identifier = id
            return id
        }
    }
        
    private(set) var profile: ProfileViewModel?
    
    func saveProfile(profile: ProfileViewModel, completion: @escaping (Bool) -> Void) {
        profileDataManager.writeToDisk(newProfile: profile, oldProfile: profile, completion: completion)
    }
        
    func loadProfile(completion: @escaping (ProfileViewModel) -> Void) {
        profileDataManager.readProfileFromDisk { (profile) in
            if let profile = profile {
                self.profile = profile
                completion(profile)
            } else {
                let defaultProfile = ProfileViewModel(fullName: "Marat Dzhanybaev",
                                                      description: "Love coding, bbq and beer",
                                                      avatar: nil)
                self.profileDataManager.writeToDisk(newProfile: defaultProfile, oldProfile: nil) { _ in
                    self.profile = defaultProfile
                    completion(defaultProfile)
                }
            }
        }
    }
    
}
