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
}

class AvatarService: IAvatarService {
    
    let networkManager: INetworkManager
    let apiKey: String
    
    init(networkManager: INetworkManager, apiKey: String) {
        self.networkManager = networkManager
        self.apiKey = apiKey
    }
    
    func loadImageList(handler: @escaping((Result<[String], Error>) -> Void)) {
        networkManager.send(request: ImageListRequest(apiKey: apiKey),
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
}
