//
//  MmsImageView.swift
//  Shroud
//
//  Created by Lynk on 11/24/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class MmsImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.imageView?.backgroundColor = .gray
        return button
    }()
    
    let pictureTap = UITapGestureRecognizer()
    
    private func commonInit() {
        addGestureRecognizer(pictureTap)
        clipsToBounds = true
        contentMode = .scaleAspectFill
        backgroundColor = .black
        isUserInteractionEnabled = true
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1).isActive = true
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cancelButton.imageView?.clipsToBounds = false
        cancelButton.imageView?.layer.cornerRadius = 10
        cancelButton.imageView?.layer.cornerCurve = .continuous
    }
}
