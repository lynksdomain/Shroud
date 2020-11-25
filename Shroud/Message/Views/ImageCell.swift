//
//  ImageCell.swift
//  Shroud
//
//  Created by Lynk on 11/24/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
    lazy var pictureView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .gray
        return image
    }()
        
    let tap = UITapGestureRecognizer()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
     func commonInit() {
        selectionStyle = .none
        backgroundColor = .black
        contentView.addSubview(pictureView)
        contentView.isUserInteractionEnabled = true
        pictureView.addGestureRecognizer(tap)
        pictureView.isUserInteractionEnabled = true
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        pictureView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        pictureView.widthAnchor.constraint(equalTo: pictureView.heightAnchor).isActive = true
        pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11).isActive = true
        pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11).isActive = true
        
        
    }
    
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pictureView.layer.cornerRadius = 20
        pictureView.layer.cornerCurve = .continuous
        pictureView.layer.masksToBounds = true
    }
}
