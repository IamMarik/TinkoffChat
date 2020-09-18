//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Marik on 18.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        return imagePicker
    }()

    @IBOutlet var profilePhotoImageView: UIImageView!

    @IBOutlet var profileNameLabel: UILabel!

    @IBOutlet var profileDescriptionLabel: UILabel!

    @IBOutlet var editButton: UIButton!

    @IBOutlet var saveButton: UIButton!


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // В конструкторе IBOutlet-ы ещё не проинициализированы, опционал развернется с ошибкой
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Здесь вью загружены в память, но размеры ещё не расчитывались
        Log.info("Edit button frame in viewDidLoad: \(editButton.frame)", tag: "\(Self.self)")
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Здесь все вью в уже иерархии с пересчитанными размерами согласно констрейтам
        Log.info("Edit button frame in viewDidAppear: \(editButton.frame)", tag: "\(Self.self)")
    }

    private func setupView() {
        profilePhotoImageView.layer.cornerRadius = 120
        saveButton.layer.cornerRadius = 14
    }

    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
    }

    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
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
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        profilePhotoImageView.backgroundColor = .clear
        profilePhotoImageView.image = image
    }
}
