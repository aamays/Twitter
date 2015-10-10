//
//  AppExtensions.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

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