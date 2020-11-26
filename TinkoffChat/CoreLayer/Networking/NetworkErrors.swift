//
//  NetworkErrors.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

enum NetworkErrors: Error {
    case invalidURL(_ string: String)
    case parseError
    case invalidRequest
    case unacceptableResponseCode(_ code: Int)
    case illegalFormat
}
