//
//  ProgrammaticView.swift
//  Shroud
//
//  Created by Lynk on 10/12/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit


class ProgrammaticView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame:  UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {}
}
