//
//  ProfileDiskManager.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 09.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit


final class GCDDataManager: DataManagerProtocol {
        
    func writeToDisk(newProfile: ProfileViewModel, oldProfile: ProfileViewModel?, completion: @escaping((Bool) -> Void)) {
        let group = DispatchGroup()
        var successWritingName = true
        var successWritingDescription = true
        var successWritingAvatar = true
        
        if newProfile.fullName != oldProfile?.fullName ||
            !FileUtils.fileExist(fileName: ProfileItemsStoreKeys.fullName.rawValue) {
            group.enter()
            DispatchQueue.global(qos: .utility).async {
                successWritingName = FileUtils.writeToDisk(
                    data: newProfile.fullName.data(using: .utf8),
                    fileName: ProfileItemsStoreKeys.fullName.rawValue
                )
                group.leave()
            }
        }
        
        if newProfile.description != oldProfile?.description ||
            !FileUtils.fileExist(fileName: ProfileItemsStoreKeys.description.rawValue) {
            group.enter()
            DispatchQueue.global(qos: .utility).async {
                successWritingDescription = FileUtils.writeToDisk(
                    data: newProfile.fullName.data(using: .utf8),
                    fileName: ProfileItemsStoreKeys.description.rawValue
                )
                group.leave()
            }
        }
        
        if newProfile.avatar !== oldProfile?.avatar ||
            !FileUtils.fileExist(fileName: ProfileItemsStoreKeys.avatar.rawValue) {
            group.enter()
            DispatchQueue.global(qos: .utility).async {
                if let imageData = newProfile.avatar?.pngData() {
                    successWritingAvatar = FileUtils.writeToDisk(
                        data: imageData,
                        fileName: ProfileItemsStoreKeys.avatar.rawValue)
                } else {
                    successWritingAvatar = false
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let successWriting = successWritingName && successWritingDescription && successWritingAvatar
            completion(successWriting)
        }
    }
    
    
    func readProfileFromDisk(completion: @escaping((ProfileViewModel?) -> Void)) {
        DispatchQueue.global(qos: .utility).async {
            if let nameData = FileUtils.readFromDisk(fileName: ProfileItemsStoreKeys.fullName.rawValue),
               let descriptionData = FileUtils.readFromDisk(fileName: ProfileItemsStoreKeys.description.rawValue),
               let avatarData = FileUtils.readFromDisk(fileName: ProfileItemsStoreKeys.avatar.rawValue),
               let name = String(data: nameData, encoding: .utf8),
               let description = String(data: descriptionData, encoding: .utf8),
               let avatar = UIImage(data: avatarData) {
                
                let profile = ProfileViewModel(fullName: name, description: description, avatar: avatar)
                
                completion(profile)
              
            } else {
                completion(nil)
            }
        }
    }
    
}
