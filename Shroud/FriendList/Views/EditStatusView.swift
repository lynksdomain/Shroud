//
//  EditStatusView.swift
//  Shroud
//
//  Created by Lynk on 10/13/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit


class EditStatusView: ProgrammaticView {
    lazy var statusTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .black
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isEditable = true
        tv.keyboardAppearance = .dark
        tv.returnKeyType = UIReturnKeyType.done
        return tv
    }()
        
    override func commonInit() {
        backgroundColor = .black
        addSubview(statusTextView)
        statusTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([statusTextView.topAnchor.constraint(equalTo: topAnchor,constant: 20),
                                     statusTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                     statusTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                                     statusTextView.heightAnchor.constraint(equalToConstant: 200)])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
}
