//
//  Extensions.swift
//  Shroud
//
//  Created by Lynk on 9/16/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit



extension UIView {

    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
        case .Top: border.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: thickness)
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        }

        layer.addSublayer(border)
    }
}



extension UIColor {
    var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0,0,0,0)
    }
}

