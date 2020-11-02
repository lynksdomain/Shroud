//
//  EditingView.swift
//  Shroud
//
//  Created by Lynk on 9/18/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit



class EditingView: UIView {
    lazy var boldText: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        button.setTitle("B", for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    
    
    lazy var lightText: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .light)
        button.setTitle("L", for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    
    
    lazy var redText: UIButton = {
        let button = UIButton()
        button.setAttributedTitle( NSAttributedString(string: "A", attributes:
                                                        [.underlineStyle: NSUnderlineStyle.single.rawValue]) , for: .selected)
        button.setAttributedTitle( NSAttributedString(string: "A", attributes:
                                                        [:]) , for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    lazy var whiteText: UIButton = {
        let button = UIButton()
        button.isSelected = true
        button.setAttributedTitle( NSAttributedString(string: "A", attributes:
                                                        [.underlineStyle: NSUnderlineStyle.single.rawValue]) , for: .selected)
        button.setAttributedTitle( NSAttributedString(string: "A", attributes:
                                                        [:]) , for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)

        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var smallText: UIButton = {
        let button = UIButton()
        button.setTitle("T", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    lazy var largeText: UIButton = {
        let button = UIButton()
        button.setTitle("T", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.gray, for: .normal)
        return button
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
        let stack = UIStackView(arrangedSubviews: [lightText,boldText,whiteText,redText,smallText,largeText])
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5.0
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    }
}
