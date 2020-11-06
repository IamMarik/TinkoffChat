//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Marik on 20.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

struct ProfileViewModel {
    let fullName: String
    let description: String
    let avatar: UIImage
    let isStubAvatar: Bool
    
    init(fullName: String, description: String, avatar: UIImage?) {
        self.fullName = fullName
        self.description = description
        self.avatar = avatar ?? ProfilePlaceholderImageRenderer.drawProfilePlaceholderImage(
            forName: fullName,
            inRectangleOfSize: .init(width: 240, height: 240)
        )
        self.isStubAvatar = avatar == nil
    }
}

enum ProfileItemsStoreKeys: String {
    case fullName = "profile_name"
    case description = "profile_description"
    case avatar = "profile_avatar"
}
