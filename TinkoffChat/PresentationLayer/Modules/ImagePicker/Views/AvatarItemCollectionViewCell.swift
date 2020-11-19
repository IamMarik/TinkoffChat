//
//  AvatarItemCollectionViewCell.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 16.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

struct AvatarItemViewModel {
    let urlPath: String
    var image: UIImage?
    var isFetching: Bool = false
}

class AvatarItemCollectionViewCell: UICollectionViewCell, ConfigurableView {
    
    static let imagePlaceholder: UIImage? = UIImage(named: "ImagePlaceholder")

    @IBOutlet private var imageView: UIImageView!
    
    func configure(with model: AvatarItemViewModel) {
       imageView.image = model.image ?? Self.imagePlaceholder
       contentView.backgroundColor = Themes.current.colors.primaryBackground
    }
}
