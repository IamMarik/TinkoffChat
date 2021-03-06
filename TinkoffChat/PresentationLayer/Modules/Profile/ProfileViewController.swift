//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Marik on 18.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var profile: ProfileViewModel?
    
    var userDataStore: IUserDataStore?
    
    var presentationAssembly: IPresenentationAssembly?
    
    var logger: ILogger?
    
    var onProfileChanged: ((ProfileViewModel) -> Void)?
    
    private var currentState: ProfileViewState = .initial
        
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        return imagePicker
    }()
    
    private lazy var loadingViewController = LoadingViewController()
    
    @IBOutlet private var scrollView: UIScrollView!

    @IBOutlet private var profileNavigationBar: ProfileNavigationBar!
    
    @IBOutlet private var profileAvatarImageView: UIImageView!

    @IBOutlet private var profileNameLabel: UILabel!

    @IBOutlet private var profileNameTextField: UITextField! {
        didSet {
            profileNameTextField.accessibilityIdentifier = AccessibilityIdentifiers.profileNameTextField
        }
    }
    
    @IBOutlet private var profileDescriptionTextView: UITextView! {
        didSet {
            profileDescriptionTextView.accessibilityIdentifier = AccessibilityIdentifiers.profileDescriptionTextView
        }
    }
    
    @IBOutlet private var editAvatarButton: UIButton!
     
    @IBOutlet private var saveButtonsStackView: UIStackView!
    
    @IBOutlet private var saveGCDButton: UIButton! {
        didSet {
            saveGCDButton.accessibilityIdentifier = AccessibilityIdentifiers.profileEditButton
        }
    }
 
    /// Стейты вьюхи. Сделал String для дебага
    enum ProfileViewState: String {
        case initial
        // Просмотр профиля
        case view
        // В режиме редактирования
        case editing
        // Есть изменения в режиме редактирования
        case hasChanges
        // Происходит сохранение профиля
        case saving
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTheme()
        setupKeyboard()
        updateData()
        changeView(state: .view)
    }
    
    private func setupView() {
        saveGCDButton.layer.cornerRadius = 14
        profileAvatarImageView.layer.cornerRadius = 120
        profileNavigationBar.delegate = self
        profileNameTextField.delegate = self
        profileNameTextField.addTarget(self, action: #selector(checkProfileDataForChanges), for: .editingChanged)
        profileDescriptionTextView.delegate = self
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func updateData() {
        profileNameLabel.text = profile?.fullName ?? ""
        profileDescriptionTextView.text = profile?.description ?? ""
        profileAvatarImageView.image = profile?.avatar 
    }
    
    private func setupTheme() {
        let theme = Themes.current
        view.backgroundColor = theme.colors.primaryBackground
        profileNameLabel.textColor = theme.colors.profile.name
        profileNameTextField.textColor = theme.colors.profile.name
        profileDescriptionTextView.textColor = theme.colors.profile.description
        saveGCDButton.backgroundColor = theme.colors.profile.saveButtonBackground
    }

    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        } else {
            logger?.error("Photo library source is not available")
            showAlert(withTitle: "Error", message: "Photo gallery is not available")
        }
    }

    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            logger?.error("Camera source is not available")
            showAlert(withTitle: "Error", message: "Camera is not available")
        }
    }
    
    private func openNetworkImagePicker() {
        guard let imagePickerViewController = presentationAssembly?.networkImagePickerViewController(delegate: self) else {
            return
        }
        present(imagePickerViewController, animated: true, completion: nil)
    }

    private func showAlert(withTitle title: String, message: String, retryAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
 
        alertController.set(title: title, color: Themes.current.colors.profile.actionSheet.text)
        alertController.set(message: message, color: Themes.current.colors.profile.actionSheet.text)
        alertController.set(backgroundColor: Themes.current.colors.profile.actionSheet.background)
        
        let closeAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alertController.addAction(closeAction)
        if let retryAction = retryAction {
            alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) in
                retryAction()
            }))
        }

        present(alertController, animated: true, completion: nil)
    }
    
    private func changeView(state: ProfileViewState) {
        guard currentState != state else { return }
        logger?.info("Changing state to: \(state.rawValue)")
        currentState = state
        switch state {
        case .initial:
            break
        case .view:
            editAvatarButton.isHidden = true
            saveGCDButton.isEnabled = true
            saveGCDButton.setTitle("Edit", for: .normal)
            profileNameTextField.isHidden = true
            profileNameLabel.isHidden = false
            profileDescriptionTextView.isEditable = false
            profileDescriptionTextView.isSelectable = false
            loadingViewController.hide()
            saveButtonsStackView.animateShaking(false)
        case .editing:
            editAvatarButton.isHidden = false
            saveGCDButton.isEnabled = false
            saveGCDButton.setTitle("Save", for: .normal)
            profileNameLabel.isHidden = true
            profileNameTextField.isHidden = false
            profileNameTextField.text = profile?.fullName
            profileDescriptionTextView.isEditable = true
            profileDescriptionTextView.isSelectable = true
            saveButtonsStackView.animateShaking(true)
        case .hasChanges:
            saveGCDButton.isEnabled = true
        case .saving:
            loadingViewController.show(in: view)
            saveGCDButton.isEnabled = false
        }
     
    }
  
    private func saveProfileChanges() {
        logger?.info("Saving profile")
        changeView(state: .saving)
        let newProfile = ProfileViewModel(
            fullName: profileNameTextField.text ?? "",
            description: profileDescriptionTextView.text ?? "",
            avatar: profileAvatarImageView.image)
        
        userDataStore?.saveProfile(profile: newProfile, completion: { [weak self] (success) in
            if success {
                self?.userDataStore?.loadProfile(completion: { (loadedProfile) in
                    DispatchQueue.main.async {
                        self?.changeView(state: .view)
                        self?.profile = loadedProfile
                        self?.updateData()
                        self?.onProfileChanged?(loadedProfile)
                        self?.showAlert(withTitle: "Success", message: "Profile was successful saved")
                    }
                })
            } else {
                DispatchQueue.main.async {
                    self?.changeView(state: .view)
                    self?.showAlert(withTitle: "Error", message: "Error during saving profile", retryAction: {
                        self?.saveProfileChanges()
                    })
                }
            }
        })
    }
    
    @IBAction func editAvatarButtonDidTap(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Edit photo", message: "Please, choose one of the ways", preferredStyle: .actionSheet)
        
        alertController.set(title: "Edit photo", color: Themes.current.colors.profile.actionSheet.text)
        alertController.set(message: "Please, choose one of the ways", color: Themes.current.colors.profile.actionSheet.text)
        alertController.set(backgroundColor: Themes.current.colors.profile.actionSheet.background)
 
        let takeShotAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        
        let chooseFromGalleryAction = UIAlertAction(title: "Photo Gallery", style: .default) { _ in
            self.openGallery()
        }
        
        let chooseFromNetwork = UIAlertAction(title: "Load from network", style: .default) { _ in
            self.openNetworkImagePicker()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        alertController.addAction(takeShotAction)
        alertController.addAction(chooseFromGalleryAction)
        alertController.addAction(chooseFromNetwork)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        switch currentState {
        case .initial, .editing, .saving:
            break
        case .view:
            changeView(state: .editing)
        case .hasChanges:
            // Сохраняем профайл
            saveProfileChanges()
        }
    }
    
    @objc func checkProfileDataForChanges() {
        // Проверяем изменились ли данные от исходных по контенту, изображение проверяем по ссылке объекта.
        // Сравнивать данные изображения считаю накладным и бессмысленным в данном кейсе.
        let hasDataChanges =
            profile?.fullName != profileNameTextField.text ||
            profile?.description != profileDescriptionTextView.text ||
            profile?.avatar !== profileAvatarImageView.image
        changeView(state: hasDataChanges ? .hasChanges : .editing)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let offsetHeight = keyboardSize.height + 20
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: offsetHeight, right: 0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
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
            checkProfileDataForChanges()
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.profileAvatarImageView.image = image
           
        } else {
            logger?.error("Awaited an image from UIImagePickerController, but got nil")
        }
        picker.dismiss(animated: true) {
            self.checkProfileDataForChanges()          
        }
    }
}

extension ProfileViewController: ImagePickerViewControllerDelegate {
    func imagePicker(_ viewController: ImagePickerViewController, didSelectedImage image: UIImage?) {
        if let image = image {
            profileAvatarImageView.image = image
        } else {
            logger?.error("Awaited an image from ImagePickerViewController, but got nil")
        }
        viewController.dismiss(animated: true) {
            self.checkProfileDataForChanges()
        }
    }
}

extension ProfileViewController: ProfileNavigationBarDelegate {
    
    func closeButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
}
