//
//  ImageListRequest.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class ImageListRequest: IRequest {
       
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: host)
        urlComponents?.queryItems = []
        urlComponents?.queryItems?.append(.init(name: "key", value: apiKey))
        urlComponents?.queryItems?.append(.init(name: "image_type", value: imageType))
        guard let url = urlComponents?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    private let apiKey: String
    
    private let host = "https://pixabay.com/api/"
    
    private let imageType = "photo"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
 
}
