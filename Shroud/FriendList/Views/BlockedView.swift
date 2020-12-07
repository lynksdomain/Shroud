//
//  BlockedView.swift
//  Shroud
//
//  Created by Lynk on 12/2/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class BlockedView: ProgrammaticView {

    lazy var blockedTableView: UITableView = {
        let tv = UITableView()
        tv.register(BlockedCell.self, forCellReuseIdentifier:
            "blockedCell")
        tv.backgroundColor = .black
        tv.separatorInset = UIEdgeInsets.zero
        return tv
    }()
    
    override func commonInit() {
        backgroundColor = .black
        addSubview(blockedTableView)
        blockedTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([blockedTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
                                     blockedTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     blockedTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     blockedTableView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }

}
