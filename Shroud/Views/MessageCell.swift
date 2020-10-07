//
//  MessageCell.swift
//  Shroud
//
//  Created by Lynk on 9/16/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

enum MessageCellType {
    case user, friend
}

class MessageCell: UITableViewCell {
    
    lazy var senderLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .black
        addSubview(senderLabel)
        addSubview(messageLabel)
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setFormatting(message: Message, sender: String) {
        switch message.fontColor {
        case .white:
            messageLabel.textColor = .white
        case.red:
            messageLabel.textColor = .red
        }
        
        switch (message.fontType, message.fontSize) {
        case (.bold,.large):
            messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        case (.bold,.regular):
            messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        case (.bold,.small):
            messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        case (.regular,.large):
            messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        case (.regular,.regular):
            messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        case (.regular,.small):
            messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        case (.light,.large):
            messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .ultraLight)
        case (.light,.regular):
            messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
        case (.light,.small):
            messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .ultraLight)
        }
        senderLabel.text = sender
        messageLabel.text = message.message
    }
    
}
