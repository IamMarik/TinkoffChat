//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 26.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    let sections: [ConversationSection] = ConversationSectionsMockData.sections
    
    var userProfile: ProfileViewModel = {
        let profile = ProfileViewModel(fullName: "Marat Dzhanybaev",
                                       description: "Love coding, bbq and beer",
                                       photo: nil)
        return profile
    }()
    
    private let cellId = String(describing: ConversationTableViewCell.self)
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var settingsBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var profileBarButtonItem: UIBarButtonItem!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        Themes.current.statusBarStyle
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tinkoff chat"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setupTableView()
        setupNavigationBar()
        setupTheme()
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
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor:theme.colors.navigationBar.title]
            navBarAppearance.backgroundColor = theme.colors.navigationBar.background
          
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
        }
        setNeedsStatusBarAppearanceUpdate()        
        
        settingsBarButtonItem.tintColor = theme.colors.navigationBar.tint
    }
    
    private func setupNavigationBar() {
        let photo = userProfile.photo ?? ProfilePlaceholderImageRenderer.drawProfilePlaceholderImage(forName: userProfile.fullName, inRectangleOfSize: CGSize(width: 36, height: 36))
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        button.setImage(photo, for: .normal)
        button.addTarget(self, action: #selector(profileItemDidTap), for: .touchUpInside)

        let barButton = UIBarButtonItem()
        barButton.customView = button
        self.navigationItem.rightBarButtonItem = barButton
   
    }
    
    @objc private func profileItemDidTap() {
        guard let profileViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profileId") as? ProfileViewController else { return }
        profileViewController.profile = self.userProfile
        navigationController?.present(profileViewController, animated: true, completion: nil)
    }
    
    @IBAction func settingsItemDidTap(_ sender: Any) {
        guard let themesViewController = UIStoryboard(name: "ThemeSettings", bundle: nil).instantiateViewController(withIdentifier: "ThemeSettingsId") as? ThemesViewController else { return }
        
        themesViewController.delegate = self
        
        themesViewController.onThemeDidChanged = { [weak self] themeOption in
            Themes.saveApplicationTheme(themeOption)
            self?.setupTheme()
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(themesViewController, animated: true)
    }
    
}


extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        let conversation = sections[indexPath.section].conversations[indexPath.row]
        cell.configure(with: conversation)      
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return !section.conversations.isEmpty ? section.title : nil
    }
    
    
}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let conversationViewController = UIStoryboard(name: "Conversation", bundle: nil)
                .instantiateViewController(withIdentifier: "conversationId") as? ConversationViewController else {
            return
        }
        let conversation = sections[indexPath.section].conversations[indexPath.row]
        conversationViewController.title = conversation.name
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
        Themes.saveApplicationTheme(themeOption)
        setupTheme()
        tableView.reloadData()
    }
    
}
