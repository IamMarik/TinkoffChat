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
    
    @IBOutlet var messageVisibleView: UIView!
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var inputTextView: UITextView!
    
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var inputMaxHeightConstraint: NSLayoutConstraint!
        
    @IBOutlet var messageContainerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!
    
    var messageVisibleBottomConstraint: NSLayoutConstraint?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        if let channel = self.channel {
            messageService = MessageService(channel: channel)
        }
        setupView()
        setupTheme()
        setupKeyboard()
        subscribeOnMessagesUpdates()
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
        messageContainer.backgroundColor = Themes.current.colors.conversation.inputTextView
        bottomView.backgroundColor = Themes.current.colors.conversation.bottomViewBackground       
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func subscribeOnMessagesUpdates() {
        messageService?.subscribeOnMessages(handler: { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.messages = messages
                    self?.tableView.reloadData()
                    self?.scrollToBottom()
                case .failure:
                    break
                }
            }
        })
    }
    
    private func scrollToBottom(animated: Bool = true) {
        guard messages.count > 0 else { return }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    @IBAction func sendButtonDidTap(_ sender: Any) {
        guard let content = inputTextView.text else { return }
        self.inputTextView.resignFirstResponder()
        self.inputTextView.text = ""
        messageService?.addMessage(
            content: content) { [weak self] (result) in
            DispatchQueue.main.async {
                if case Result.failure(_) = result {
                    let alert = UIAlertController.themeAlert(
                        title: "Error",
                        message: "Error during adding new message, try later.",
                        actions: [.init(title: "Got it", style: .default)])
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let offsetHeight = keyboardSize.height
        messageVisibleBottomConstraint = messageVisibleView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -offsetHeight)
        messageVisibleBottomConstraint?.isActive = true
        scrollToBottom(animated: true)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        messageVisibleBottomConstraint?.isActive = false
        messageVisibleView.layoutIfNeeded()
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
