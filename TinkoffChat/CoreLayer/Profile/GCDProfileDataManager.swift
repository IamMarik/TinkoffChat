//
//  ProfileDiskManager.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 09.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

final class GCDProfileDataManager: IProfileDataManager {
    
    var logger: ILogger?
        
    func writeToDisk(newProfile: ProfileViewModel, oldProfile: ProfileViewModel?, completion: @escaping((Bool) -> Void)) {
        let group = DispatchGroup()
        var successWritingName = true
        var successWritingDescription = true
        var successWritingAvatar = true
        
        if newProfile.fullName != oldProfile?.fullName ||
            !FileUtils.fileExist(fileName: ProfileItemsStoreKeys.fullName.rawValue) {
            group.enter()
            DispatchQueue.global(qos: .utility).async { [weak self] in
                self?.logger?.info("Write profile name with GCD")
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
            DispatchQueue.global(qos: .utility).async { [weak self] in
                self?.logger?.info("Write profile description with GCD")
                successWritingDescription = FileUtils.writeToDisk(
                    data: newProfile.description.data(using: .utf8),
                    fileName: ProfileItemsStoreKeys.description.rawValue
                )
                group.leave()
            }
        }
        
        if !newProfile.isStubAvatar,
           newProfile.avatar !== oldProfile?.avatar {
            group.enter()
            DispatchQueue.global(qos: .utility).async { [weak self] in
                self?.logger?.info("Write profile avatar with GCD")
                if let imageData = newProfile.avatar.jpegData(compressionQuality: 1.0) {
                    successWritingAvatar = FileUtils.writeToDisk(
                        data: imageData,
                        fileName: ProfileItemsStoreKeys.avatar.rawValue)
                } else {
                    successWritingAvatar = false
                }
                group.leave()
            }
        }
        
        group.notify(queue: .global(qos: .default)) { [weak self] in
            self?.logger?.info("Complete writing profile with GCD")
            let successWriting = successWritingName && successWritingDescription && successWritingAvatar
            completion(successWriting)
        }
    }
    
    func readProfileFromDisk(completion: @escaping((ProfileViewModel?) -> Void)) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.logger?.info("Read profile with GCD")
            if let nameData = FileUtils.readFromDisk(fileName: ProfileItemsStoreKeys.fullName.rawValue),
               let descriptionData = FileUtils.readFromDisk(fileName: ProfileItemsStoreKeys.description.rawValue),
               let name = String(data: nameData, encoding: .utf8),
               let description = String(data: descriptionData, encoding: .utf8) {
                let avatarData = FileUtils.readFromDisk(fileName: ProfileItemsStoreKeys.avatar.rawValue)
                var avatar: UIImage?
                if let data = avatarData {
                    avatar = UIImage(data: data)
                }
                let profile = ProfileViewModel(fullName: name, description: description, avatar: avatar)
                
                completion(profile)
              
            } else {
                completion(nil)
            }
        }
    }
    
}
