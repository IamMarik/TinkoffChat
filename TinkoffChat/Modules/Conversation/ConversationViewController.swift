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
    
    var channel: ChannelDB?
    
    var messages: [Message] = []
    
    let cellId = "\(MessageTableViewCell.self)"

    @IBOutlet var tableView: UITableView!

    var messageVisibleBottomConstraint: NSLayoutConstraint?
    
    lazy var messageInputView: MessageInputView = {
        let view = MessageInputView()
        view.delegate = self
        return view
    }()
    
    var shouldScrollToBottom: Bool = false
    
    override var inputAccessoryView: UIView? {
        return messageInputView
    }
    
    override var canBecomeFirstResponder: Bool { true }
    
    override var canResignFirstResponder: Bool { true }
  
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        becomeFirstResponder()
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "\(MessageTableViewCell.self)", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .none
    }
    
    private func setupTheme() {
        view.backgroundColor = Themes.current.colors.primaryBackground
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
                    self?.scrollToBottom(animated: true)
                case .failure:
                    break
                }
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldScrollToBottom {
            shouldScrollToBottom = false
            scrollToBottom(animated: false)
        }
    }
    
    func scrollToBottom(animated: Bool) {
        // Не всегда хорошо скроллит до низа, возможно стоит покопать в сторону расчета высоты ячеек по тексту
        tableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: animated)
    }
        
    @objc func keyboardWillShow(notification: NSNotification) {
        adjustContentForKeyboard(shown: true, notification: notification)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        adjustContentForKeyboard(shown: false, notification: notification)
    }
    
    private func adjustContentForKeyboard(shown: Bool, notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
        let keyboardHeight = shown ? keyboardSize.height : messageInputView.bounds.size.height
        if tableView.contentInset.bottom == keyboardHeight {
            return
        }

        var insets = tableView.contentInset
        insets.bottom = keyboardHeight
             
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.2
        let curveOptions = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationOptions ?? .curveEaseOut
                
        UIView.animate(withDuration: duration, delay: 0, options: curveOptions, animations: {
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets

        }, completion: nil)
    }
    
    private func bottomOffset() -> CGPoint {
        return CGPoint(x: 0, y: max(-tableView.contentInset.top, tableView.contentSize.height - (tableView.bounds.size.height - tableView.contentInset.bottom)))
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

extension ConversationViewController: MessageInputViewDelegate {
    
    func send(text: String) {
        DispatchQueue.main.async {
            self.resignFirstResponder()
            self.messageInputView.clearInput()
        }
        messageService?.addMessage(
            content: text) { [weak self] (result) in
            DispatchQueue.main.async {
                if case Result.failure(_) = result {
                    let alert = UIAlertController.themeAlert(
                        title: "Error",
                        message: "Error during adding new message, try later.",
                        actions: [.init(title: "Got it", style: .default)])
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    self?.shouldScrollToBottom = true
                }
            }
        }
    }
}
