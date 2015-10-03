//
//  AppConstants.swift
//  Twitter
//
//  Created by Amay Singhal on 9/30/15.
//  Copyright © 2015 ple. All rights reserved.
//

import Foundation
import UIKit

struct AppConstants {
    static let UserDidLoginNotification = "info.amays.UserDidLoginNotification"
    static let UserDidLogoutNotification = "info.amays.UserDidLogoutNotificationKey"

    static let OAuthCallbackUrl = NSURL(string: "aktwitter://oauth")

    static let UserInfoArchiveFilename = "userinfoarchive"

    static let TwitterBlueColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1)
    static let ApplicationBarTintColor = UIColor.whiteColor()

    struct MainStoryboard {
        static let ShowHomeTimelineSegueIdentifier = "Show Home Timeline"
        static let HomeTimelineVCIdentifier = "HomeTimelineViewController"
        static let TwitterLoginVCIdentifier = "TwitterLoginViewController"
        static let HomeTimelineNavVCIdentifier = "HomeTimelineNavigationViewController"
    }

}