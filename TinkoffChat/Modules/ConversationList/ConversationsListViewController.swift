//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 26.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    lazy var channelsService = ChannelsService()
    
    var channels: [Channel] = []
        
    //var userProfile: ProfileViewModel?
     
    var profileDataManager: DataManagerProtocol = GCDDataManager()
    
    private let cellId = String(describing: ConversationTableViewCell.self)
    
    lazy var profileAvatarButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.layer.cornerRadius = 18
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(profileItemDidTap), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var settingsBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var profileBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var addChannelBarButtonItem: UIBarButtonItem!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        Themes.current.statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Channels"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setupTableView()
        setupNavigationBar()
        setupTheme()
        loadProfile()
        loadChannels()
    }
        
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "\(ConversationTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(ConversationTableViewCell.self)")
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupTheme() {
        let theme = Themes.current
        view.backgroundColor = theme.colors.primaryBackground
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
            navBarAppearance.backgroundColor = theme.colors.navigationBar.background
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = theme.colors.navigationBar.background
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
        }
       
        navigationController?.isNavigationBarHidden = true
        navigationController?.isNavigationBarHidden = false
        setNeedsStatusBarAppearanceUpdate()        
        tableView.separatorColor = Themes.current.colors.conversationList.table.separator
        settingsBarButtonItem.tintColor = theme.colors.navigationBar.tint
        addChannelBarButtonItem.tintColor = theme.colors.navigationBar.tint
    }
    
    private func setupNavigationBar() {
        let barItem = UIBarButtonItem(customView: profileAvatarButton)
        barItem.customView?.widthAnchor.constraint(equalToConstant: 36).isActive = true
        barItem.customView?.heightAnchor.constraint(equalToConstant: 36).isActive = true
        navigationItem.rightBarButtonItem = barItem
        profileAvatarButton.isEnabled = false
    }
    
    private func loadProfile() {
        UserData.shared.loadProfile { [weak self] (profile) in
            self?.updateProfile(profile: profile)
        }
    }
    
    private func loadChannels() {
        channelsService.subscribeOnChannels { [weak self] (result) in
            switch result {
            case .success(let channels):
                DispatchQueue.main.async {
                    self?.channels = channels
                    // По-хорошему можно обновлять с анимацией добавления, перемещения канала
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                Log.error("Error during update channels: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateProfile(profile: ProfileViewModel) {
        RunLoop.main.perform(inModes: [.default]) { [weak self] in
            self?.profileAvatarButton.isEnabled = true
            self?.profileAvatarButton.setImage(profile.avatar, for: .normal)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController.themeAlert(title: "Error", message: message)
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func profileItemDidTap() {
        guard let profile = UserData.shared.profile else { return }
        guard let profileViewController = UIStoryboard(name: "Profile", bundle: nil)
                .instantiateViewController(withIdentifier: "profileId") as? ProfileViewController else { return }
        profileViewController.profile = profile
        profileViewController.onProfileChanged = { [weak self] (profile) in
            self?.updateProfile(profile: profile)
        }
        navigationController?.present(profileViewController, animated: true, completion: nil)
    }
    
    @IBAction func settingsItemDidTap(_ sender: Any) {
        guard let themesViewController = UIStoryboard(name: "ThemeSettings", bundle: nil)
                .instantiateViewController(withIdentifier: "ThemeSettingsId") as? ThemesViewController else { return }
        
        themesViewController.delegate = self
        navigationController?.pushViewController(themesViewController, animated: true)
    }
    
    @IBAction func addChannelItemDidTap(_ sender: Any) {
        
        let alert = UIAlertController.themeAlert(title: "Adding new channel", message: "")
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter channel name here..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in
            if let name = alert.textFields?.first?.text,
               !name.isEmpty {
                self?.channelsService.createChannel(name: name) { (result) in
                    if case Result.failure(_) = result {
                        self?.showErrorAlert(message: "Error during create new channel, try later.")
                    }
                }
            } else {
                self?.showErrorAlert(message: "Channel name can't be empty.")
            }
        }))
        present(alert, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        let channel = channels[indexPath.row]
        cell.configure(with: channel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Channel list"
    }
    
}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let conversationViewController = UIStoryboard(name: "Conversation", bundle: nil)
                .instantiateViewController(withIdentifier: "conversationId") as? ConversationViewController else {
            return
        }
        let chanel = channels[indexPath.row]
        conversationViewController.title = chanel.name
        conversationViewController.channel = chanel
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = Themes.current.colors.conversationList.table.sectionHeaderBackground
        headerView.textLabel?.textColor = Themes.current.colors.conversationList.table.sectionHeaderTitle
        
    }
    
}

extension ConversationsListViewController: ThemesPickerDelegate {
    
    func themeDidChanged(on themeOption: ThemeOptions) {
        setupTheme()
        tableView.reloadData()
    }
    
}
