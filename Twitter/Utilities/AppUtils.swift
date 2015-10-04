//
//  AppUtils.swift
//  Twitter
//
//  Created by Amay Singhal on 10/2/15.
//  Copyright © 2015 ple. All rights reserved.
//

import Foundation
import UIKit

struct AppUtils {

    static func getUserDirectory() -> String {
        let userDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return userDir[0]
    }

    static func getUserInfoArchiveFilePath() -> String {
        return "\(AppUtils.getUserDirectory())/\(AppConstants.UserInfoArchiveFilename)"
    }

    static func updateTextAndTintColorForNavBar(navController: UINavigationController, tintColor: UIColor?, textColor: UIColor?) {
        navController.navigationBar.barTintColor = tintColor ?? AppConstants.TwitterBlueColor
        navController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: textColor ?? AppConstants.ApplicationBarTintColor]
    }

    static func getAttributedStringForActionButtons(message: String, iconText: String, iconTextColor: UIColor = UIColor.darkGrayColor(), withIconSize size: CGFloat = 15, andBaseLine baseline: CGFloat = -3) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        if let font = UIFont(name: FontasticIcons.FontName, size: size) {
            let attrs = [NSFontAttributeName : font,
                NSBaselineOffsetAttributeName: baseline,
                NSForegroundColorAttributeName: iconTextColor]
            let cautionSign = NSMutableAttributedString(string: iconText, attributes: attrs)
            attributedString.appendAttributedString(cautionSign)
            message.characters.count > 0 ? attributedString.appendAttributedString(NSAttributedString(string: " ")) : ()
        }

        attributedString.appendAttributedString(NSAttributedString(string: message))
        return attributedString
    }

    static func shakeUIView(targetView: UIView, withOffset offset: CGFloat = 5) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(targetView.center.x - offset, targetView.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(targetView.center.x + offset, targetView.center.y))
        targetView.layer.addAnimation(animation, forKey: "position")
    }
}