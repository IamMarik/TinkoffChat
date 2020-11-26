//
//  ResponseParser.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol IResponseParser {
    associatedtype Model
    
    func parse(data: Data) -> Model?
}

class DecodableParser<Model: Decodable>: IResponseParser {
    
    func parse(data: Data) -> Model? {
        let decoder = JSONDecoder()
        let model = try? decoder.decode(Model.self, from: data)
        return model
    }
}

class RawParser: IResponseParser {
    func parse(data: Data) -> Data? {
        return data
    }
}
