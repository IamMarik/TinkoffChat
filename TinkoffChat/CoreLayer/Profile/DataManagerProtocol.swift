//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 09.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol IProfileDataManager {
    
    func writeToDisk(newProfile: ProfileViewModel, oldProfile: ProfileViewModel?, completion: @escaping((Bool) -> Void))
    
    func readProfileFromDisk(completion: @escaping((ProfileViewModel?) -> Void))
}
