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
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        trailingContainerConstraint.isActive = model.direction == .outgoing
        setupTheme(for: model.direction)
    }
    
    func setupTheme(for direction: MessageDirection) {
        let themeColors = Themes.current.colors.conversation.cell
        let directionTheme = direction == .incoming ? themeColors.incoming : themeColors.outgoing
        containerView.backgroundColor = directionTheme.background
        messageLabel.textColor = directionTheme.text
    }
}
