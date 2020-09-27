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
        .init(text: "Hello, what's up?"),
        .init(text: "Hi, there! I'm great and you?")
       ]
    }()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "\(MessageTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(MessageTableViewCell.self)")
    }


}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MessageTableViewCell.self)", for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: messages[indexPath.row])
        return cell
    }
    
    
}

