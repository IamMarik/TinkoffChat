//
//  ImageRequest.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 18.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlPath) else {
            return nil
        }
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    }
    
    let urlPath: String
    
    init(urlPath: String) {
        self.urlPath = urlPath
    }
}
