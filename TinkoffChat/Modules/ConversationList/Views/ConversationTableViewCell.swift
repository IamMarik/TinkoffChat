//
//  ConversationTableViewCell.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 26.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    static let todayDateFormatter = DateFormatter(format: "HH:mm")
    
    static let commonDateFormatter = DateFormatter(format: "dd MMM")
    
    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var receivedDateLabel: UILabel!

    @IBOutlet var disclosureImageView: UIImageView!
    
    @IBOutlet var isOnlineContainerView: UIView!
    
    @IBOutlet var isOnlineIndicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isOnlineContainerView.layer.cornerRadius = isOnlineContainerView.frame.width / 2
        isOnlineIndicatorView.layer.cornerRadius = isOnlineIndicatorView.frame.width / 2
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
        photoImageView.clipsToBounds = true
    }
        
}

extension ConversationTableViewCell: ConfigurableView {
    
    func configure(with model: ConversationCellModel) {
        let theme = Themes.current
        
        nameLabel.text = model.name
        
        messageLabel.text = !model.message.isEmpty ? model.message : "No messages yet"
        let dateFormatter = Calendar.current.isDateInToday(model.date) ? Self.todayDateFormatter : Self.commonDateFormatter
        receivedDateLabel.text = !model.message.isEmpty ? dateFormatter.string(from: model.date) : ""
        
        if model.message.isEmpty {
            messageLabel.font = UIFont.italicSystemFont(ofSize: 13)  
        } else if model.hasUnreadMessage {
            messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        } else {
            messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        }
        
        photoImageView.image = ProfilePlaceholderImageRenderer.drawProfilePlaceholderImage(forName: model.name, inRectangleOfSize: .init(width: 120, height: 120))
        
        isOnlineContainerView.isHidden = !model.isOnline
        nameLabel.textColor = theme.colors.conversationList.cell.name
        messageLabel.textColor = theme.colors.conversationList.cell.message
        receivedDateLabel.textColor = theme.colors.conversationList.cell.receivedDate
        disclosureImageView.tintColor = theme.colors.conversationList.cell.receivedDate
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = theme.colors.conversationList.cell.cellSelected
        self.selectedBackgroundView = selectedBackgroundView
    }
    
}
