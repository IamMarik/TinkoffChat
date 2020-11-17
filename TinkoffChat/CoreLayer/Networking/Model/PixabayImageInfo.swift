//
//  PixabayImageInfo.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

struct PixabayImageSearchResponse: Decodable {
    let total: Int?
    let hits: [PixabayImageInfo]?
}

struct PixabayImageInfo: Decodable {
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "webformatURL"
    }
}
