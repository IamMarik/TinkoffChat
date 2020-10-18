//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 27.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var messageService: MessageService?
    
    var channel: Channel?
    
    var messages: [Message] = []
    
    let cellId = "\(MessageTableViewCell.self)"

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var messageContainer: UIView!
    
    @IBOutlet var inputTextView: UITextView!
    
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var inputMaxHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var messageContainerBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let channel = self.channel {
            messageService = MessageService(channel: channel)
        }
        setupView()
        setupTheme()
        setupKeyboard()
        loadMessages()
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "\(MessageTableViewCell.self)", bundle: nil), forCellReuseIdentifier: cellId)
        
        messageContainer.layer.borderWidth = 0.5
        messageContainer.layer.cornerRadius = 16
        
        inputTextView.delegate = self
        inputView?.backgroundColor = .red
        
    }
    
    private func setupTheme() {
        view.backgroundColor = Themes.current.colors.primaryBackground
        messageContainer.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func loadMessages() {
        messageService?.getMessages { [weak self] (messages) in
            self?.messages = messages
            self?.tableView.reloadData()
        } failure: { (error) in
            
        }

    }
    
    @IBAction func sendButtonDidTap(_ sender: Any) {
        guard let content = inputTextView.text else { return }
        messageService?.addMessage(
            content: content,
            successful: { [weak self] in
                self?.loadMessages()
                self?.inputTextView.resignFirstResponder()
                self?.inputTextView.text = ""
            }, failure: { (error) in
                
            })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let offsetHeight = keyboardSize.height
        messageContainerBottomConstraint.constant = offsetHeight
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        messageContainerBottomConstraint.constant = 0
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

extension ConversationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let isOversize = textView.contentSize.height >= inputMaxHeightConstraint.constant
        let shouldInvalidateContenSize = !isOversize && textView.isScrollEnabled
        textView.isScrollEnabled = isOversize
        inputMaxHeightConstraint.isActive = isOversize
        if shouldInvalidateContenSize {
            textView.invalidateIntrinsicContentSize()
        }
    }
}
