//
//  NetworkManager.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol INetworkManager {
    func send<Model, Parser>(request: IRequest, parser: Parser, handler: @escaping(Result<Model, Error>) -> Void) where Parser: IResponseParser, Parser.Model == Model
}

class NetworkManager: INetworkManager {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func send<Model, Parser>(request: IRequest, parser: Parser, handler: @escaping(Result<Model, Error>) -> Void) where Model == Parser.Model, Parser: IResponseParser {
        
        guard let urlRequest = request.urlRequest else {
            handler(.failure(NetworkErrors.invalidRequest))
            return
        }        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                handler(.failure(error))
                return
            } else if let response = (response as? HTTPURLResponse),
                      !((200..<300) ~= response.statusCode) {
                handler(.failure(NetworkErrors.unacceptableResponseCode(response.statusCode)))
            } else if let data = data {
                if let model = parser.parse(data: data) {
                    handler(.success(model))
                } else {
                    handler(.failure(NetworkErrors.parseError))
                }
            }
        }
        
        task.resume()
    }
    
}
