//
//  MessageTableViewCell.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 27.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var senderLabel: UILabel!
    
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var trailingContainerConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        containerView.layer.shadowRadius = 1.63
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
}

extension MessageTableViewCell: ConfigurableView {
    func configure(with model: Message) {
        let isMyMessage = model.isMyMessage
        messageLabel.text = model.content
        senderLabel.text = isMyMessage ? "" : model.senderName 
        trailingContainerConstraint.isActive = isMyMessage
        senderLabel.isHidden = isMyMessage
        setupTheme(isMyMessage: isMyMessage)
        invalidateIntrinsicContentSize()
    }
    
    func setupTheme(isMyMessage: Bool) {
        let themeColors = Themes.current.colors.conversation.cell
        let directionTheme = isMyMessage ? themeColors.outgoing : themeColors.incoming
        containerView.backgroundColor = directionTheme.background
        messageLabel.textColor = directionTheme.text
    }
}
