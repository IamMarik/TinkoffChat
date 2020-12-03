//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 26.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController {
    
    var channelsService: IChannelsService?
    
    var userDataStore: IUserDataStore?
    
    var logger: ILogger?
    
    var presentationAssembly: IPresenentationAssembly?
 
    var fetchedResultsController: NSFetchedResultsController<ChannelDB>?
        
    private let cellId = String(describing: ConversationTableViewCell.self)
    
    private var fetchesCount = 0
        
    lazy var profileAvatarButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.layer.cornerRadius = 18
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(profileItemDidTap), for: .touchUpInside)
        button.accessibilityIdentifier = AccessibilityIdentifiers.profileBarButton
        return button
    }()
    
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet private var settingsBarButtonItem: UIBarButtonItem!
    
    @IBOutlet private var profileBarButtonItem: UIBarButtonItem!
    
    @IBOutlet private var addChannelBarButtonItem: UIBarButtonItem!
    
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
        fetchChannels()
       // emitEmblemOnTouch()
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
        userDataStore?.loadProfile { [weak self] (profile) in
            DispatchQueue.main.async {
                self?.updateProfile(profile: profile)
            }            
        }
    }
    
    private func fetchChannels() {
        do {
            // Загружаем уже сохраненные каналы из бд
            try fetchedResultsController?.performFetch()
        } catch {
            showErrorAlert(message: error.localizedDescription)
            logger?.error(error.localizedDescription)
        }
        // Подписываемся на обновления из firestore
        subscribeOnChannelUpdates()
    }
    
    private func subscribeOnChannelUpdates() {
        fetchedResultsController?.delegate = self
        channelsService?.subscribeOnChannelsUpdates { [weak self] (result) in
            if case Result.failure(let error) = result {
                self?.logger?.error(error.localizedDescription)
            }
        }
    }
        
    private func updateProfile(profile: ProfileViewModel) {
        profileAvatarButton.isEnabled = true
        profileAvatarButton.setImage(profile.avatar, for: .normal)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController.themeAlert(title: "Error", message: message)
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func createChannel(name: String) {
        channelsService?.createChannel(name: name) { [weak self] (result) in
            if case Result.failure(_) = result {
                self?.showErrorAlert(message: "Error during create new channel, try later.")
            }
        }
    }
    
    @objc private func profileItemDidTap() {
        guard let profile = userDataStore?.profile else { return }
        guard let profileViewController = presentationAssembly?.profileViewController(transitioningDelegate: self) else { return }
        profileViewController.profile = profile
        profileViewController.onProfileChanged = { [weak self] (profile) in
            DispatchQueue.main.async {
                self?.updateProfile(profile: profile)
            }
        }
        navigationController?.present(profileViewController, animated: true, completion: nil)
    }
    
    @IBAction func settingsItemDidTap(_ sender: Any) {
        guard let themesViewController = presentationAssembly?.settingsViewController() else { return }
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
            if let nameText = alert.textFields?.first?.text {
                let name = nameText.trimmingCharacters(in: .whitespacesAndNewlines)
                if !name.isEmpty {
                    self?.createChannel(name: name)
                } else {
                    self?.showErrorAlert(message: "Channel name can't be empty")
                }
            } else {
                self?.showErrorAlert(message: "Channel name can't be nil.")
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
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ConversationTableViewCell,
              let channel = fetchedResultsController?.object(at: indexPath)
            else {
            return UITableViewCell()
        }
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
       
        guard let channel = fetchedResultsController?.object(at: indexPath),
              let conversationVC = presentationAssembly?.conversationViewController(channelId: channel.identifier, channelName: channel.name) else {
            return
        }
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = Themes.current.colors.conversationList.table.sectionHeaderBackground
        headerView.textLabel?.textColor = Themes.current.colors.conversationList.table.sectionHeaderTitle
    }
            
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let channel = self.fetchedResultsController?.object(at: indexPath) else { return }
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Confirmation", message: "Do you realy want to delete channel \(channel.name)", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
                self?.channelsService?.deleteChannel(with: channel.identifier) { (result) in
                    switch result {
                    case .success:
                        self?.logger?.info("Successful delete channel \(channel.name)")
                    case .failure(let error):
                        self?.showErrorAlert(message: error.localizedDescription)
                        self?.logger?.error("Error during deleting channel \(channel.name). \(error.localizedDescription)")
                    }
                }
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension ConversationsListViewController: ThemesPickerDelegate {
    
    func themeDidChanged(on themeOption: ThemeOptions) {
        setupTheme()
        tableView.reloadData()
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        UIView.setAnimationsEnabled(fetchesCount > 1)
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        tableView.layoutIfNeeded()
        fetchesCount += 1
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        let withoutAnimation = fetchesCount < 2
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: withoutAnimation ? .none : .automatic)
            }
        case .update:
            if let indexPath = indexPath,
               let cell = tableView.cellForRow(at: indexPath) as? ConversationTableViewCell,
               let channel = fetchedResultsController?.object(at: indexPath) {
                cell.configure(with: channel)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .none)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: withoutAnimation ? .none : .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: withoutAnimation ? .none : .fade)
            }
        @unknown default:
            fatalError()
        }
        
    }
}
