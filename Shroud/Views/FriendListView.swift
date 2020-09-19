//
//  FriendListView.swift
//  Shroud
//
//  Created by Lynk on 9/9/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class FriendListView: UIView {
    
    lazy var friendListTableView: UITableView = {
        let tv = UITableView()
        tv.register(FriendListCell.self, forCellReuseIdentifier:
            "FriendCell")
        tv.backgroundColor = .black
        //tv.separatorColor = .lightGray
        tv.separatorInset = UIEdgeInsets.zero
        return tv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .black
        addFriendList()
    }
    
    private func addFriendList() {
        friendListTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(friendListTableView)
        friendListTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        friendListTableView.leadingAnchor.constraint(equalTo:leadingAnchor).isActive = true
        friendListTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    
    
}
