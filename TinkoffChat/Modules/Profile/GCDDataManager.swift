//
//  ProfileDiskManager.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 09.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit


final class GCDDataManager: DataManagerProtocol {
    
    private let nameFileName = "profile_name"
    private let descriptionFileName = "profile_description"
    private let avatarFileName = "profile_avatar"

    
    func writeToDisk(newProfile: ProfileViewModel, oldProfile: ProfileViewModel?, completion: @escaping((Bool) -> Void)) {
        let group = DispatchGroup()
        var successWritingName = false
        var successWritingDescription = false
        var successWritingAvatar = false
        
        if newProfile.fullName != oldProfile?.fullName {
            group.enter()
            DispatchQueue.global(qos: .utility).async {
                successWritingName = self.writeToDisk(data: newProfile.fullName.data(using: .utf8), fileName: self.nameFileName)
                group.leave()
            }
        }
        
        if newProfile.description != oldProfile?.description {
            group.enter()
            DispatchQueue.global(qos: .utility).async {
                successWritingDescription = self.writeToDisk(
                    data: newProfile.fullName.data(using: .utf8),
                    fileName: self.descriptionFileName)
                group.leave()
            }
        }
        
        if newProfile.avatar !== oldProfile?.avatar {
            group.enter()
            DispatchQueue.global(qos: .utility).async {
                if let imageData = newProfile.avatar?.pngData() {
                    successWritingAvatar = self.writeToDisk(
                        data: imageData,
                        fileName: self.avatarFileName)
                } else {
                    successWritingAvatar = false
                }
               
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let successWriting = successWritingName || successWritingDescription || successWritingAvatar
            completion(successWriting)
        }
    }
    
    func readProfileFromDisk(completion: @escaping((ProfileViewModel?) -> Void)) {
        DispatchQueue.global(qos: .utility).async {
            if let nameData = self.readFromDisk(fileName: self.nameFileName),
               let descriptionData = self.readFromDisk(fileName: self.descriptionFileName),
               let avatarData = self.readFromDisk(fileName: self.avatarFileName),
               let name = String(data: nameData, encoding: .utf8),
               let description = String(data: descriptionData, encoding: .utf8),
               let avatar = UIImage(data: avatarData) {
                
                let profile = ProfileViewModel(fullName: name, description: description, avatar: avatar)
                
                DispatchQueue.main.async {
                    completion(profile)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func writeToDisk(data: Data?, fileName: String) -> Bool {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try data?.write(to: url)
            return true
        } catch {
            return false
        }
    }
    
    private func readFromDisk(fileName: String) -> Data? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        let data = try? Data(contentsOf: url)
        return data
    }
    
}
