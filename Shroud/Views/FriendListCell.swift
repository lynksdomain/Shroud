//
//  FriendListCell.swift
//  Shroud
//
//  Created by Lynk on 9/10/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class FriendListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .black
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
