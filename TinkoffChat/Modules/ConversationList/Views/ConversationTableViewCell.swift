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
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var receivedDateLabel: UILabel!

    @IBOutlet var disclosureImageView: UIImageView!
            
}

extension ConversationTableViewCell: ConfigurableView {
    
    func configure(with model: Channel) {
        let theme = Themes.current
        
        nameLabel.text = model.name
        
        messageLabel.text = model.lastMessage ?? "No messages yet"
        
        if let lastActivityDate = model.lastActivity {
           let dateFormatter = Calendar.current.isDateInToday(lastActivityDate) ? Self.todayDateFormatter : Self.commonDateFormatter
            receivedDateLabel.text = dateFormatter.string(from: lastActivityDate)
        } else {
            receivedDateLabel.text = ""
        }
                
        if model.lastMessage == nil {
            messageLabel.font = UIFont.italicSystemFont(ofSize: 13)
        } else {
            messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        }
        
        nameLabel.textColor = theme.colors.conversationList.cell.name
        messageLabel.textColor = theme.colors.conversationList.cell.message
        receivedDateLabel.textColor = theme.colors.conversationList.cell.receivedDate
        disclosureImageView.tintColor = theme.colors.conversationList.cell.receivedDate
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = theme.colors.conversationList.cell.cellSelected
        self.selectedBackgroundView = selectedBackgroundView
    }
    
}
