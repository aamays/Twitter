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
}