//
//  AvatarListViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 16.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

protocol ImagePickerViewControllerDelegate: AnyObject {
    func imagePicker(_ viewController: ImagePickerViewController, didSelectedImage image: UIImage?)
}

class ImagePickerViewController: UIViewController {
    
    var avatarService: IAvatarService?
    
    var logger: ILogger?
    
    weak var delegate: ImagePickerViewControllerDelegate?
    
    var imageViewModels: [AvatarItemViewModel] = []
    
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
        avatarService?.loadImageList(handler: { [weak self] (result) in
            switch result {
            case .success(let imageLinkList):
                let avatarModels = imageLinkList.map {
                    AvatarItemViewModel(urlPath: $0, image: nil)
                }
                self?.update(with: avatarModels)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func update(with avatarModels: [AvatarItemViewModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.imageViewModels = avatarModels
            self?.collectionView.reloadData()
        }
    }
    
    private func fetchImage(at index: Int, for model: AvatarItemViewModel) {
        var copyModel = model
        copyModel.isFetching = true
        imageViewModels[index] = copyModel
        avatarService?.loadImage(urlPath: copyModel.urlPath) { [weak self] (result) in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else {
                    self?.logger?.error("Error parsing data image for url: \(copyModel.urlPath)")
                    return
                }
                copyModel.isFetching = false
                copyModel.image = image
                self?.updateCell(at: index, with: copyModel)
            case .failure(let error):
                self?.logger?.error("Error fetching image for url: \(copyModel.urlPath). \(error.localizedDescription)")
            }
        }
    }
    
    private func updateCell(at index: Int, with model: AvatarItemViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.imageViewModels[index] = model
            self?.collectionView.reloadItems(at: [.init(item: index, section: 0)])
        }
    }
        
}

extension ImagePickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AvatarItemCollectionViewCell.self)", for: indexPath) as? AvatarItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        let imageModel = imageViewModels[indexPath.item]
        cell.configure(with: imageModel)
        if imageModel.image == nil && !imageModel.isFetching {
            fetchImage(at: indexPath.item, for: imageModel)
        }
        return cell
    }
    
}

extension ImagePickerViewController: UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageModel = imageViewModels[indexPath.item]
        guard let image = imageModel.image else {
            return
        }
        delegate?.imagePicker(self, didSelectedImage: image)
    }
    
}
