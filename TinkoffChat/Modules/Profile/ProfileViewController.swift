//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Marik on 18.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    static var logTag = "\(ProfileViewController.self)"

    var profile: ProfileViewModel?

    lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        return imagePicker
    }()
    
    
    @IBOutlet var profileNavigationBar: ProfileNavigationBar!
    
    @IBOutlet var profilePhotoImageView: UIImageView!

    @IBOutlet var profileNameLabel: UILabel!

    @IBOutlet var profileDescriptionLabel: UILabel!

    @IBOutlet var editButton: UIButton!

    @IBOutlet var saveButton: UIButton!

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // В конструкторе IBOutlet-ы ещё не проинициализированы, опционал аутлета развернется с ошибкой
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileNavigationBar.delegate = self
        // Здесь вью загружены в память, но размеры и позиция по констрейтам ещё не расчитывались.
        // Размеры фрейма будут соответствовать начальным (со сториборда в данном случае)
        Log.info("Save button frame in viewDidLoad: \(saveButton.frame)", tag: Self.logTag)
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Здесь все вью уже иерархии с пересчитанными согласно констрейтам размерами
        Log.info("Save button frame in viewDidAppear: \(saveButton.frame)", tag: Self.logTag)
    }

    private func setupView() {
        saveButton.layer.cornerRadius = 14
        profilePhotoImageView.layer.cornerRadius = 120

        if let profile = self.profile {
            if let photo = profile.photo {
                profilePhotoImageView.image = photo
            } else {
                let image = ProfilePlaceholderImageRenderer.drawProfilePlaceholderImage(forName: profile.fullName, inRectangleOfSize: .init(width: 240, height: 240))
                profilePhotoImageView.image = image
            }
            profileNameLabel.text = profile.fullName
            profileDescriptionLabel.text = profile.description
        }
    }

    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        } else {
            Log.error("Photo library source is not available", tag: Self.logTag)
            showErrorAlert(withMessage: "Фотогалерея не доступна")
        }
    }

    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            Log.error("Camera source is not available", tag: Self.logTag)
            showErrorAlert(withMessage: "Камера не доступна")
        }
    }

    private func showErrorAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Понятно", style: .cancel, handler: nil)
        alert.addAction(closeAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func editButtonDidTap(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "Изображение", preferredStyle: .actionSheet)

        let chooseFromGalleryAction = UIAlertAction(title: "Выбрать из библиотеки", style: .default) { _ in
            self.openGallery()
        }

        let takeShotAction = UIAlertAction(title: "Сделать фотографию", style: .default) { _ in
            self.openCamera()
        }

        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)

        alertController.addAction(chooseFromGalleryAction)
        alertController.addAction(takeShotAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    @IBAction func saveButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.profilePhotoImageView.image = image
        } else {
            Log.error("Awaited an image from UIImagePickerController, but got nil")
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: ProfileNavigationBarDelegate {
    
    func closeButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
