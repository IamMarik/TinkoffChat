//
//  AvatarListViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 16.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class AvatarListViewController: UIViewController {
    
    var avatarService: IAvatarService?
    
    var imageViewModels: [AvatarItemViewModel] = [
        .init(urlPath: "", image: nil),
        .init(urlPath: "", image: nil),
        .init(urlPath: "", image: nil),
        .init(urlPath: "", image: nil),
        .init(urlPath: "", image: nil),
        .init(urlPath: "", image: nil),
        .init(urlPath: "", image: nil),
        .init(urlPath: "", image: nil)
    ]
    
    private var itemPerRow: CGFloat = 3
    
    private let itemSpacing: CGFloat = 10
 
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadAvatarList()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "\(AvatarItemCollectionViewCell.self)", bundle: nil),
                                forCellWithReuseIdentifier: "\(AvatarItemCollectionViewCell.self)")
    }
    
    private func loadAvatarList() {
        avatarService?.loadImageList(handler: { (result) in
            switch result {
            case .success(let models):
                print(models)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}

extension AvatarListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AvatarItemCollectionViewCell.self)", for: indexPath) as? AvatarItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = imageViewModels[indexPath.item]
        cell.configure(with: viewModel)
        return cell
    }
    
}

extension AvatarListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = itemSpacing * (itemPerRow + 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let itemWidth = (availableWidth / itemPerRow).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
}
