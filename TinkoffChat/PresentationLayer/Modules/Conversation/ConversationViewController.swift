//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 27.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
    
    var channelId: String?
    
    var messageService: IMessageService?
    
    var fetchedResultsController: NSFetchedResultsController<MessageDB>?
        
    private let cellId = "\(MessageTableViewCell.self)"
        
    private lazy var messageInputView: MessageInputView = {
        let view = MessageInputView()
        view.delegate = self
        return view
    }()
    
    private var shouldScrollToBottom: Bool = false
    
    private var fetchesCount: Int = 0
       
    @IBOutlet private var tableView: UITableView!
    
    override var inputAccessoryView: UIView? {
        return messageInputView
    }
    
    override var canBecomeFirstResponder: Bool { true }
    
    override var canResignFirstResponder: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTheme()
        setupKeyboard()
        fetchMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldScrollToBottom {
            shouldScrollToBottom = false
            scrollToBottom(animated: false)
        }
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
    
    private func fetchMessages() {
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            // showErrorAlert(message: error.localizedDescription)
            Log.error(error.localizedDescription)
        }
        subscribeOnMessagesUpdates()
    }
    
    private func subscribeOnMessagesUpdates() {
        fetchedResultsController?.delegate = self
        messageService?.subscribeOnMessagesUpdates(handler: { (result) in
            if case Result.failure(let error) = result {
                Log.error(error.localizedDescription)
            }
        })
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
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell,
              let message = fetchedResultsController?.object(at: indexPath) else {
            return UITableViewCell()
        }
      
        cell.configure(with: message)
        return cell
    }
    
}

extension ConversationViewController: MessageInputViewDelegate {
    
    func send(text: String) {
        DispatchQueue.main.async {
            self.resignFirstResponder()
            self.messageInputView.clearInput()
        }
        let sendMessage = text.trimmingCharacters(in: .whitespacesAndNewlines)
        messageService?.addMessage(
            content: sendMessage) { [weak self] (result) in
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

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Этот костыль убережёт нас от дергания ячеек при первых двух обновлениях
        // 1 - это удаление всех сообщений, при получении первой порции данных
        // 2 - добавление всех сообщений канала
        // Все остальные изменения, например новые сообщения, будут приходить с плавной анимацией
        UIView.setAnimationsEnabled(fetchesCount > 1)
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
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
               let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell,
               let message = fetchedResultsController?.object(at: indexPath) {                
                cell.configure(with: message)
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
