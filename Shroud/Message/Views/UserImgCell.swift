//
//  UserImgCell.swift
//  Shroud
//
//  Created by Lynk on 11/24/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit


class UserImgCell: ImageCell {
    override func commonInit() {
        super.commonInit()
        pictureView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11).isActive = true
    }
    
    
}
