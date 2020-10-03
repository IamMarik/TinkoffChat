//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 27.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var messages: [MessageCellModel] = {
       return [
        .init(text: "Hello, what's up?", direction: .incoming),
        .init(text: "Hi, there! I'm great do you hear about Lorem Ipsum?", direction: .outgoing),
        .init(text: "Nope. Show it...", direction: .incoming),
        .init(text: "Just a little bit...😉", direction: .incoming),
        .init(text: "Here we go", direction: .outgoing),
        .init(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", direction: .outgoing),
        .init(text: "Stop this😂😂😂", direction: .incoming),
        .init(text: "Est velit egestas dui id ornare. Amet risus nullam eget felis eget. Augue ut lectus arcu bibendum at varius vel pharetra vel. Porttitor massa id neque aliquam. Massa ultricies mi quis hendrerit dolor magna eget est. Ut morbi tincidunt augue interdum velit euismod in pellentesque massa. Mollis nunc sed id semper risus in. Sit amet nisl suscipit adipiscing bibendum. Suspendisse in est ante in nibh mauris cursus mattis. Mollis aliquam ut porttitor leo a diam. In est ante in nibh mauris cursus.", direction: .outgoing)
       ]
    }()
    
    let cellId = "\(MessageTableViewCell.self)"

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTheme()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "\(MessageTableViewCell.self)", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func setupTheme() {
        view.backgroundColor = ThemeManager.shared.theme.colors.primaryBackground
    }
}

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: messages[indexPath.row])
        return cell
    }
    
}

