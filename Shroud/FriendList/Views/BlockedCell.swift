//
//  BlockedCell.swift
//  Shroud
//
//  Created by Lynk on 12/2/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit
import Kingfisher

class BlockedCell: UITableViewCell {

    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    lazy var avatar: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var unblockButton: UIButton = {
        let button = UIButton()
        button.setTitle("Unblock", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .black
        selectionStyle = .none
        contentView.addSubview(unblockButton)
        addSubview(avatar)
        addSubview(nameLabel)
        unblockButton.translatesAutoresizingMaskIntoConstraints = false
        avatar.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        setAvatarConstraints()
        setNameLabel()
        setUnblock()
    }
    
    func configureCell(user: ShroudUser) {
        nameLabel.text = user.username
        avatar.kf.setImage(with: URL(string: user.profilePicture))
    }
    
    
    private func setAvatarConstraints() {
        NSLayoutConstraint.activate([avatar.heightAnchor.constraint(equalToConstant: 50),
                                     avatar.widthAnchor.constraint(equalToConstant: 50),
                                     avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
                                     avatar.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setNameLabel() {
        NSLayoutConstraint.activate([ nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 11),
                                      nameLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor)
        ])
        
    }
    
    private func setUnblock() {
        NSLayoutConstraint.activate([ unblockButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 11),
                                      unblockButton.centerYAnchor.constraint(equalTo: centerYAnchor ),
                                      unblockButton.heightAnchor.constraint(equalToConstant: 30),
                                      unblockButton.widthAnchor.constraint(equalToConstant: 80),
                                      unblockButton.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -11)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.clipsToBounds = true
        unblockButton.layer.borderWidth = 0.5
        unblockButton.layer.borderColor = UIColor.white.cgColor
        unblockButton.layer.cornerRadius = 5
    }
}
