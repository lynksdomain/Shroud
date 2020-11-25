//
//  FriendImgCell.swift
//  Shroud
//
//  Created by Lynk on 11/24/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit


class FriendImgCell: ImageCell {
    override func commonInit() {
        super.commonInit()
        pictureView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11).isActive = true
    }
    
    
}

