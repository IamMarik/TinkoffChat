//
//  MessageInputView.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 21.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

protocol MessageInputViewDelegate: AnyObject {
    
    func send(text: String)
}

class MessageInputView: UIView {
    
    weak var delegate: MessageInputViewDelegate?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var messageLineView: UIView!
    
    @IBOutlet var inputTextView: UITextView!
    
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var inputTextViewHeightConstraint: NSLayoutConstraint!
    
    override var intrinsicContentSize: CGSize {
        let textSize = inputTextView.sizeThatFits(CGSize(width: inputTextView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: bounds.width, height: textSize.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("\(MessageInputView.self)", owner: self, options: nil)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.frame = bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        inputTextView.delegate = self
        
        messageLineView.layer.cornerRadius = 14
        messageLineView.layer.borderColor = UIColor.lightGray.cgColor
    
        messageLineView.backgroundColor = Themes.current.colors.conversation.input.background
        inputTextView.textColor = Themes.current.colors.conversation.input.text
        contentView.backgroundColor = Themes.current.colors.conversation.bottomViewBackground
    }
    
    func clearInput() {
        inputTextView.text = ""
    }
    
    @IBAction func sendButtonDidTap(_ sender: Any) {
        delegate?.send(text: inputTextView.text ?? "")
    }
    
}

extension MessageInputView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let isOversize = textView.contentSize.height >= 120
        let shouldInvalidateContenSize = !isOversize && textView.isScrollEnabled
        textView.isScrollEnabled = isOversize
        inputTextViewHeightConstraint.isActive = isOversize
        if shouldInvalidateContenSize {
            textView.invalidateIntrinsicContentSize()
        }
    }
}
