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
    
    var currentState: ProfileViewState = .view
    
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var profileNavigationBar: ProfileNavigationBar!
    
    @IBOutlet var profileAvatarImageView: UIImageView!

    @IBOutlet var profileNameLabel: UILabel!

    @IBOutlet var profileNameTextField: UITextField!
    
    @IBOutlet var profileDescriptionTextView: UITextView!
    
    @IBOutlet var editAvatarButton: UIButton!
 
    @IBOutlet var loadingView: UIView!
    
    @IBOutlet var saveButtonsStackView: UIStackView!
    
    @IBOutlet var saveGCDButton: UIButton!
 
    @IBOutlet var saveOperationButton: UIButton!
    
    
    /// Стейты вьюхи. Сделал String для дебага
    enum ProfileViewState: String{
        // Загрузка профиля
        case loading
        // Просмотр профиля
        case view
        // В режиме редактирования
        case editing
        // Есть изменения в режиме редактирования
        case hasChanges
        // Происходит сохранение профиля
        case saving
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTheme()
        setupKeyboard()
        updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Не совсем понял из задания каким менеджером читать данные, поэтому пусть решает всемогущий рэндом
        if profile == nil {
            let dataManager: DataManagerProtocol = Bool.random() ? gcdDataManager : operationDataManager
            loadProfile(with: dataManager)
        }        
    }

    private func setupView() {
        saveGCDButton.layer.cornerRadius = 14
        saveOperationButton.layer.cornerRadius = 14
        profileAvatarImageView.layer.cornerRadius = 120
        loadingView.layer.cornerRadius = 14
        loadingView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        loadingView.layer.shadowRadius = 1.63
        loadingView.layer.shadowOffset = CGSize(width: 0, height: 2)
        profileNavigationBar.delegate = self
        profileNameTextField.delegate = self
        profileNameTextField.addTarget(self, action: #selector(checkProfileDataForChanges), for: .editingChanged)
        profileDescriptionTextView.delegate = self
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
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
        saveOperationButton.backgroundColor = theme.colors.profile.saveButtonBackground
        loadingView.backgroundColor = theme.colors.profile.loadingViewBackground
    }

    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        } else {
            Log.error("Photo library source is not available", tag: Self.logTag)
            showAlert(withTitle: "Error", message: "Photo gallery is not available")
        }
    }

    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            Log.error("Camera source is not available", tag: Self.logTag)
            showAlert(withTitle: "Error", message: "Camera is not available")
        }
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
        Log.info("Changing state to: \(state.rawValue)", tag: "\(Self.self)")
        currentState = state
        switch state {
        case .loading:
            loadingView.isHidden = false
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
        case .hasChanges:
            saveGCDButton.isEnabled = true
            saveOperationButton.isEnabled = true
        case .saving:
            loadingView.isHidden = false
            saveGCDButton.isEnabled = false
            saveOperationButton.isEnabled = false
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
    
    private func saveProfileChanges(with dataManager: DataManagerProtocol) {
        Log.info("Saving profile with \(dataManager.self)")
        changeView(state: .saving)
        guard let oldProfile = profile else { return }
        let newProfile = ProfileViewModel(
            fullName: profileNameTextField.text ?? "",
            description: profileDescriptionTextView.text ?? "",
            avatar: profileAvatarImageView.image)
        dataManager.writeToDisk(newProfile: newProfile, oldProfile: oldProfile) { [weak self] (success) in
            DispatchQueue.main.async {
                self?.changeView(state: .view)
                if success {
                    self?.profile = newProfile
                    self?.updateData()
                    self?.onProfileChanged?(newProfile)
                    self?.showAlert(withTitle: "Success", message: "Profile was successful saved")
                } else {
                    self?.showAlert(withTitle: "Error", message: "Error during saving profile", retryAction: {
                        self?.saveProfileChanges(with: dataManager)
                    })
                }
            }
        }
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

        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        alertController.addAction(takeShotAction)
        alertController.addAction(chooseFromGalleryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    

    // Здесь IBAction от двух кнопок сохранения
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        switch currentState {
        case .loading, .editing, .saving:
            break;
        case .view:
            changeView(state: .editing)
        case .hasChanges:
            // Определяем реализацию DataManager-а от нажатой кнопки
            let dataManager: DataManagerProtocol = sender === saveGCDButton ? gcdDataManager : operationDataManager
            // Сохраняем профайл
            saveProfileChanges(with: dataManager)
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
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let offsetHeight = keyboardSize.height + 20
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: offsetHeight, right: 0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification:NSNotification) {
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.profileAvatarImageView.image = image
           
        } else {
            Log.error("Awaited an image from UIImagePickerController, but got nil")
        }
        picker.dismiss(animated: true) {
            self.checkProfileDataForChanges()          
        }
    }
}

extension ProfileViewController: ProfileNavigationBarDelegate {
    
    func closeButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
}
