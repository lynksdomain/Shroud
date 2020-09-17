//
//  FriendListCell.swift
//  Shroud
//
//  Created by Lynk on 9/10/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class FriendListCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightText
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "This is the status"
        return label
    }()
   
    lazy var avatar: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "spy")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        return image
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    
    
    
    private func commonInit() {
        backgroundColor = .black
        selectionStyle = .none
        addAvatar()
        addName()
        addStatus()
    }
    
    private func addAvatar() {
        avatar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatar)
        avatar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
   
    private func addName() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 22).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatar.topAnchor).isActive = true

    }
    
    private func addStatus() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statusLabel)
        statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 5).isActive = true

    }

}
