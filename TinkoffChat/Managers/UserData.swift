//
//  UserData.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 18.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

/*
    Тот случай, когда я считаю допустимым использование Singleton.
    Если есть решение лучше, пожалуйста укажи в комментариях :)
 */
class UserData {
    
    static var shared: UserData = UserData()
    
    private init() { }
    
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
        
    func loadProfile(completion: @escaping (ProfileViewModel) -> Void) {
        let profileManager = GCDDataManager()
        profileManager.readProfileFromDisk { (profile) in
            if let profile = profile {
                self.profile = profile
                completion(profile)
            } else {
                let defaultProfile = ProfileViewModel(fullName: "Marat Dzhanybaev",
                                                      description: "Love coding, bbq and beer",
                                                      avatar: nil)
                profileManager.writeToDisk(newProfile: defaultProfile, oldProfile: nil) { _ in
                    self.profile = defaultProfile
                    completion(defaultProfile)
                }
            }
        }
    }
    
}
