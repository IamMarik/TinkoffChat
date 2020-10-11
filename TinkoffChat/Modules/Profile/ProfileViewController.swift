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
    
    var onProfileChanged: ((ProfileViewModel) -> Void)?
    
    var gcdDataManager = GCDDataManager()
    
    var operationDataManager = OperationDataManager()
    
    lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        return imagePicker
    }()
    
    var currentState: ProfileViewState = .initial

    @IBOutlet var profileNavigationBar: ProfileNavigationBar!
    
    @IBOutlet var profilePhotoImageView: UIImageView!

    @IBOutlet var profileNameLabel: UILabel!

    @IBOutlet var profileNameTextField: UITextField!
    
    @IBOutlet var profileDescriptionTextView: UITextView!
    
    @IBOutlet var editAvatarButton: UIButton!
 
    @IBOutlet var loadingView: UIView!
    
    @IBOutlet var saveButtonsStackView: UIStackView!
    
    @IBOutlet var saveGCDButton: UIButton!
 
    @IBOutlet var saveOperationButton: UIButton!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    enum ProfileViewState {
        case initial
        case view
        case editing
        case changing
        case loading
        case hasLoadingResult
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileNavigationBar.delegate = self
        profileNameTextField.delegate = self
        profileNameTextField.addTarget(self, action: #selector(profileDataDidChange), for: .editingChanged)
        profileDescriptionTextView.delegate = self
        setupView()
        setupTheme()
        updateData()
        changeView(state: .view)
    }

    private func setupView() {
        saveGCDButton.layer.cornerRadius = 14
        saveOperationButton.layer.cornerRadius = 14
        profilePhotoImageView.layer.cornerRadius = 120
        loadingView.layer.cornerRadius = 14
        loadingView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        loadingView.layer.shadowRadius = 1.63
        loadingView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func updateData() {
        profileNameLabel.text = profile?.fullName
        profileDescriptionTextView.text = profile?.description
        profilePhotoImageView.image = profile?.avatar
    }
    
    private func setupTheme() {
        let theme = Themes.current
        view.backgroundColor = theme.colors.primaryBackground
        profileNameLabel.textColor = theme.colors.profile.name
        profileDescriptionTextView.textColor = theme.colors.profile.description
        saveGCDButton.backgroundColor = theme.colors.profile.saveButtonBackground
        saveOperationButton.backgroundColor = theme.colors.profile.saveButtonBackground
        loadingView.backgroundColor = theme.colors.profile.loadingViewBackground
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
        
        let alertController = UIAlertController(title: "Edit photo", message: "Please, choose one of the ways", preferredStyle: .actionSheet)
        
        let attributedTitle = NSAttributedString(string: "Edit photo", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)
        ])
        
        let attributedMessage = NSAttributedString(string: "Please, choose one of the ways", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .regular)
        ])
        
        
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        let takeShotAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        
        let chooseFromGalleryAction = UIAlertAction(title: "Photo Gallery", style: .default) { _ in
            self.openGallery()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        alertController.addAction(takeShotAction)
        alertController.addAction(chooseFromGalleryAction)
        alertController.addAction(cancelAction)
        
        let contentView = alertController.view.subviews.first?.subviews.first?.subviews.first
        contentView?.backgroundColor = Themes.current.colors.profile.actionSheet.background
        present(alertController, animated: true)
    }
    
    private func changeView(state: ProfileViewState) {
        if currentState == state { return }
        currentState = state
        switch state {
        case .initial:
            changeView(state: .view)
        case .view:
            editAvatarButton.isHidden = true
            saveGCDButton.isEnabled = true
            saveGCDButton.setTitle("Edit", for: .normal)
            saveOperationButton.isHidden = true
            saveOperationButton.isEnabled = true
            profileNameTextField.isHidden = true
            profileNameLabel.isHidden = false
            profileDescriptionTextView.isEditable = false
            profileDescriptionTextView.isSelectable = false
            loadingView.isHidden = true
        case .editing:
            editAvatarButton.isHidden = false
            saveGCDButton.isEnabled = false
            saveGCDButton.setTitle("Save GCD", for: .normal)
            saveOperationButton.isEnabled = false
            saveOperationButton.isHidden = false
            profileNameLabel.isHidden = true
            profileNameTextField.isHidden = false
            profileNameTextField.text = profile?.fullName
            profileDescriptionTextView.isEditable = true
            profileDescriptionTextView.isSelectable = true
            loadingView.isHidden = true
        case .changing:
            saveGCDButton.isEnabled = true
            saveOperationButton.isEnabled = true
        case .loading:
            loadingView.isHidden = false
            saveGCDButton.isEnabled = false
            saveOperationButton.isEnabled = false
        case .hasLoadingResult:
            loadingView.isHidden = true
        }
    }
    
    private func saveProfileChanges(with dataManager: DataManagerProtocol) {
        Log.info("Saving profile with \(dataManager.self)")
        changeView(state: .loading)
        guard let oldProfile = profile else { return }
        let newProfile = ProfileViewModel(
            fullName: profileNameTextField.text ?? "",
            description: profileDescriptionTextView.text ?? "",
            avatar: profilePhotoImageView.image)
        dataManager.writeToDisk(newProfile: newProfile, oldProfile: oldProfile) { [weak self] (success) in
            DispatchQueue.main.async {
                self?.changeView(state: .hasLoadingResult)
                if success {
                    let alert = UIAlertController(title: "Success", message: "Profile was succesful saved", preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default, handler: { _ in
                        self?.profile = newProfile
                        self?.loadProfile(with: dataManager)
                        self?.onProfileChanged?(newProfile)
                    }))
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Error during saving profile", preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default, handler: { _ in
                        self?.changeView(state: .view)
                    }))
                    alert.addAction(.init(title: "Retry", style: .cancel, handler: { _ in
                        self?.saveProfileChanges(with: dataManager)
                    }))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func loadProfile(with dataManager: DataManagerProtocol) {
        changeView(state: .loading)
        dataManager.readProfileFromDisk { [weak self] (profile) in
            DispatchQueue.main.async {
                self?.profile = profile
                self?.updateData()
                self?.changeView(state: .view)
            }  
        }
    }

    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        switch currentState {
        case .initial, .editing, .loading, .hasLoadingResult:
            break;
        case .view:
            changeView(state: .editing)
        case .changing:
            let dataManager: DataManagerProtocol = sender === saveGCDButton ? gcdDataManager : operationDataManager
            saveProfileChanges(with: dataManager)
        }
    }
        
    
    @objc func profileDataDidChange() {
        let isDataChanged =
            profile?.fullName != profileNameTextField.text ||
            profile?.avatar !== profilePhotoImageView.image ||
            profile?.description != profileDescriptionTextView.text
        
        if currentState == .editing && isDataChanged {
            changeView(state: .changing)
        } else if currentState == .changing && !isDataChanged {
            changeView(state: .editing)
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension ProfileViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView === profileDescriptionTextView {
            profileDataDidChange()
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.profilePhotoImageView.image = image
        } else {
            Log.error("Awaited an image from UIImagePickerController, but got nil")
        }
        picker.dismiss(animated: true) {
            self.profileDataDidChange()
        }
    }
}

extension ProfileViewController: ProfileNavigationBarDelegate {
    
    func closeButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
}


