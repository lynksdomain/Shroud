//
//  HeadingMsgView.swift
//  Shroud
//
//  Created by Lynk on 10/8/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit
import MarqueeLabel

class HeadingMsgView: UIView {
    
    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.text = "User"
        label.textAlignment = .center
        return label
    }()
    
    lazy var statusLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30), duration: 20, fadeLength: 20)
        label.animationDelay = 0
        label.type = .continuous
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.text = "yeo im over here chilling and shieeet lets go! wooooo and some other shiet cause im trying to break my own code"
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    
    
    
    func commonInit() {
        //addSubview(backButton)
        addSubview(userLabel)
        addSubview(statusLabel)
        //backButton.translatesAutoresizingMaskIntoConstraints = false
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //NSLayoutConstraint.activate([backButton.topAnchor.constraint(equalTo: topAnchor, constant: 2),
//                                     backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
//                                     backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)])
        
        NSLayoutConstraint.activate([userLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
                                     userLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
                                     userLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11)])
        
        NSLayoutConstraint.activate([statusLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 2),
                                     statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
                                     statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
                                     statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)])
        }
    
}
