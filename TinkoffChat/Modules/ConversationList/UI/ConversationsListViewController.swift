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
                                       description: "a lot of description",
                                       photo: nil)
        return profile
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var settingsBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var profileBarButtonItem: UIBarButtonItem!
    
    
    let cellId = String(describing: ConversationTableViewCell.self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "\(ConversationTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(ConversationTableViewCell.self)")
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupNavigationBar() {
        let photo = userProfile.photo ?? ProfilePlaceholderImageRenderer.drawProfilePlaceholderImage(forName: userProfile.fullName, inRectangleOfSize: CGSize(width: 40, height: 40))
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
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
    
}
