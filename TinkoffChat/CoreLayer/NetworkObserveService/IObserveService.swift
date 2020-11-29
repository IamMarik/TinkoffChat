//
//  IObserveService.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 30.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol IObserveService: AnyObject {
        
    func subscribeOnListUpdate<Model: FirestoreModel>(handler: @escaping(Result<[Model], Error>, Int) -> Void)
    
    func add<Model: FirestoreModel>(model: Model, handler: @escaping(Result<String, Error>) -> Void)
    
    func delete(modelWithId identifier: String, handler: @escaping(Error?) -> Void)

}
