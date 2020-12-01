//
//  MockFireStoreService.swift
//  TinkoffChatTests
//
//  Created by Марат Джаныбаев on 01.12.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
@testable import TinkoffChat

class MockFirestoreService<Model: FirestoreModel>: IObserveService {
    
    var getListCount = 0
    var subscribeOnListUpdateCount = 0
    var addCount = 0
    var deleteCount = 0
    
    var getListModels: [FirestoreModel]?
    var getListError: Error?
    var subscribeModels: [FirestoreModel]?
    var subscribeError: Error?
    var subscribeCounts = 0
    var addReturnId: String?
    var addError: Error?
    var deleteHandlerError: Error?
    
    func getList<Model>(handler: @escaping (Result<[Model], Error>) -> Void) where Model: FirestoreModel {
        getListCount += 1
        if let error = getListError {
            handler(.failure(error))
        } else if let models = getListModels as? [Model] {
            handler(.success(models))
        } else {
            handler(.failure(NSError()))
        }
    }
    
    func subscribeOnListUpdate<Model>(handler: @escaping (Result<[Model], Error>, Int) -> Void) where Model: FirestoreModel {
        subscribeOnListUpdateCount += 1
        if let error = subscribeError {
            handler(.failure(error), subscribeCounts)
        } else if let models = subscribeModels as? [Model] {
            handler(.success(models), subscribeCounts)
        } else {
            handler(.failure(NSError()), subscribeCounts)
        }
    }
    
    func add<Model>(model: Model, handler: @escaping (Result<String, Error>) -> Void) where Model: FirestoreModel {
        addCount += 1
        if let error = addError {
            handler(.failure(error))
        } else if let returnId = addReturnId {
            handler(.success(returnId))
        } else {
            handler(.failure(NSError()))
        }
    }
    
    func delete(modelWithId identifier: String, handler: @escaping (Error?) -> Void) {
        deleteCount += 1
        handler(deleteHandlerError)
    }
}
