//
//  AvatarService.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol IAvatarService {
    func loadImageList(handler: @escaping((Result<[String], Error>) -> Void))
    
    func loadImage(urlPath: String, handler: @escaping((Result<Data, Error>) -> Void))
}

class AvatarService: IAvatarService {
    
    let networkManager: INetworkManager
    let apiKey: String
    let perPage: Int
    
    init(networkManager: INetworkManager, apiKey: String, perPage: Int = 100) {
        self.networkManager = networkManager
        self.apiKey = apiKey
        self.perPage = perPage
    }
    
    func loadImageList(handler: @escaping((Result<[String], Error>) -> Void)) {
        networkManager.send(request: ImageListRequest(apiKey: apiKey, perPage: perPage),
                            parser: DecodableParser<PixabayImageSearchResponse>()) { (result) in
            switch result {
            case .success(let searchResponse):
                let imageUrls = searchResponse.hits?.compactMap { $0.imageUrl } ?? []
                handler(.success(imageUrls))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func loadImage(urlPath: String, handler: @escaping ((Result<Data, Error>) -> Void)) {
        networkManager.send(request: ImageRequest(urlPath: urlPath),
                            parser: RawParser()) { (result) in
            switch result {
            case .success(let data):
                handler(.success(data))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
