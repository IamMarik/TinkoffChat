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
        nameLabel.text = model.name
        
        messageLabel.text = !model.message.isEmpty ? model.message : "No messages yet"
        if model.message.isEmpty {
            messageLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        } else if model.hasUnreadMessage {
            messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        } else {
            messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        }
       
        let dateFormatter = Calendar.current.isDateInToday(model.date) ? Self.todayDateFormatter : Self.commonDateFormatter
        receivedDateLabel.text = dateFormatter.string(from: model.date)
        
        photoImageView.image = ProfilePlaceholderImageRenderer.drawProfilePlaceholderImage(forName: model.name, inRectangleOfSize: .init(width: 240, height: 240))
        
        isOnlineContainerView.isHidden = !model.isOnline
        contentView.backgroundColor = model.hasUnreadMessage ? Colors.paleYellow : UIColor.white
    }

    
}
