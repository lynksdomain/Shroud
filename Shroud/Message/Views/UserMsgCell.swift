//
//  UserMsgCell.swift
//  Shroud
//
//  Created by Lynk on 10/7/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class UserMsgCell: MessageCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        senderLabel.textColor = ShroudColors.userBlue
        senderLabel.textAlignment = .right
        messageLabel.textAlignment = .right
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([senderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11),
                                     senderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
                                     senderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11)])
        
        NSLayoutConstraint.activate([messageLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 5),
                                     messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
                                     messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
                                     messageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75)])
    }
}
