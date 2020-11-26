//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 11.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class OperationProfileDataManager: IProfileDataManager {
    
    var logger: ILogger?
    
    lazy var operationQueue: OperationQueue =  {
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        queue.maxConcurrentOperationCount = 1  // Пусть грузит последовательно по 1-му файлу
        return queue
    }()
    
    func writeToDisk(newProfile: ProfileViewModel, oldProfile: ProfileViewModel?, completion: @escaping ((Bool) -> Void)) {
        var writeOperations = [WriteDataToDiskOperation]()
        if newProfile.fullName != oldProfile?.fullName {
            writeOperations.append(WriteDataToDiskOperation(
                                    data: newProfile.fullName.data(using: .utf8),
                                    fileName: ProfileItemsStoreKeys.fullName.rawValue)
            )
        }
        
        if newProfile.description != oldProfile?.description {
            writeOperations.append(WriteDataToDiskOperation(
                                    data: newProfile.description.data(using: .utf8),
                                    fileName: ProfileItemsStoreKeys.description.rawValue)
            )
        }
        
        if newProfile.avatar !== oldProfile?.avatar,
           !newProfile.isStubAvatar {
            writeOperations.append(WriteDataToDiskOperation(
                                    data: newProfile.avatar.jpegData(compressionQuality: 1.0),
                                    fileName: ProfileItemsStoreKeys.avatar.rawValue)
            )
        }
        
        let writeProfileOperation = WriteProfileOperation(writeOperations: writeOperations, completion: completion)
        
        let allOperations: [Operation] = writeOperations.map { $0 as Operation } + [writeProfileOperation as Operation]
        operationQueue.addOperations(allOperations, waitUntilFinished: false)
    }
    
    func readProfileFromDisk(completion: @escaping ((ProfileViewModel?) -> Void)) {
        let nameOperation = LoadDataFromDiskOperation(fileName: ProfileItemsStoreKeys.fullName.rawValue)
        let descriptionOperation = LoadDataFromDiskOperation(fileName: ProfileItemsStoreKeys.description.rawValue)
        let avatarOperation = LoadDataFromDiskOperation(fileName: ProfileItemsStoreKeys.avatar.rawValue)
        let parseProfile = ReadProfileOperation(
            nameOperation: nameOperation,
            descriptionOperation: descriptionOperation,
            avatarOperation: avatarOperation,
            completion: completion)
        operationQueue.addOperations([nameOperation, descriptionOperation, avatarOperation, parseProfile], waitUntilFinished: false)
    }
        
}

class LoadDataFromDiskOperation: Operation {
    
    let fileName: String
    var data: Data?
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    override func main() {       
        guard !isCancelled else { return }
        data = FileUtils.readFromDisk(fileName: fileName)
    }
}

class ReadProfileOperation: Operation {
    let nameOperation: LoadDataFromDiskOperation
    let descriptionOperation: LoadDataFromDiskOperation
    let avatarOperation: LoadDataFromDiskOperation
    let completion: ((ProfileViewModel?) -> Void)
    var profile: ProfileViewModel?
    
    init(nameOperation: LoadDataFromDiskOperation,
         descriptionOperation: LoadDataFromDiskOperation,
         avatarOperation: LoadDataFromDiskOperation,
         completion: @escaping ((ProfileViewModel?) -> Void) ) {
        self.nameOperation = nameOperation
        self.descriptionOperation = descriptionOperation
        self.avatarOperation = avatarOperation
        self.completion = completion
        super.init()
        addDependency(nameOperation)
        addDependency(descriptionOperation)
        addDependency(avatarOperation)
    }
    
    override func main() {
        guard !isCancelled else { return }
        guard let nameData = nameOperation.data,
              let descriptionData = descriptionOperation.data,
              let avatarData = avatarOperation.data,
              let name = String(data: nameData, encoding: .utf8),
              let description = String(data: descriptionData, encoding: .utf8),
              let avatar = UIImage(data: avatarData) else {
            
            completion(nil)
            return
        }
        profile = ProfileViewModel(fullName: name, description: description, avatar: avatar)
        completion(profile)
    }
    
}

class WriteDataToDiskOperation: Operation {
    
    let data: Data?
    let fileName: String
    var isSuccessWriting: Bool
    
    init(data: Data?, fileName: String) {
        self.data = data
        self.fileName = fileName
        isSuccessWriting = data != nil
    }
    
    override func main() {
        guard !isCancelled else { return }
        isSuccessWriting = FileUtils.writeToDisk(data: data, fileName: fileName)
    }
}

class WriteProfileOperation: Operation {
    
    let operations: [WriteDataToDiskOperation]
    
    let completion: ((Bool) -> Void)
        
    init(writeOperations: [WriteDataToDiskOperation], completion: @escaping ((Bool) -> Void) ) {
        self.operations = writeOperations
        self.completion = completion
        super.init()
        writeOperations.forEach { self.addDependency($0) }
    }
    
    override func main() {
        guard !isCancelled else {
            completion(false)
            return
        }
        let hasErrors = operations.contains(where: { !$0.isSuccessWriting })
        completion(!hasErrors)
    }
}
