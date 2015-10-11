//
//  AppExtensions.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}

extension UIView {
    func addBorderToViewAtPosition(position: BorderPotion, color: UIColor = AppConstants.Colors.LightBorderColor, andThickness thickness: CGFloat = 1) {
        let border = CALayer()
        switch position {
        case .Top:
            border.frame = CGRectMake(0, 0, self.frame.size.width, thickness)
        case .Bottom:
            border.frame = CGRectMake(0, self.bounds.height - thickness, self.frame.size.width, thickness)
//            border.frame = CGRectMake(0, 40, self.frame.size.width, thickness)
        }

        border.backgroundColor = color.CGColor
        self.layer.addSublayer(border)
    }
}

extension UIColor {
    convenience init(colorCode: String, alpha: CGFloat) {
        let scanner = NSScanner(string:colorCode)
        var color: UInt32 = 0
        scanner.scanHexInt(&color)

        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}