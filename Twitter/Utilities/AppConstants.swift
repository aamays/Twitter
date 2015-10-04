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
        static let TweetComposerVCIdentifier = "TweetComposerViewController"
        static let ComposeReplySegueIdentifier = "Compose Reply"
        static let ComposeNewStatusSegueIndentifier = "Compose New Status"
    }

    struct Colors {
        static let Green = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        static let FavoriteYellow = UIColor(red: 255/255, green: 180/255, blue: 30/255, alpha: 1)
        static let TwitterBlueColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1)
        static let LocationActivePinColor = UIColor(red: 228/255, green: 48/255, blue: 26/255, alpha: 1)
        static let MediaActiveIconColor = UIColor(red: 128/255, green: 64/255, blue: 23/255, alpha: 1)
    }
}

struct FontasticIcons {
    static let FontName = "tfontastic"
    enum Map: String {
        case Logout = "a"
        case StarFilled = "b"
        case StarEmpty = "c"
        case Reply = "d"
        case Retweet = "e"
        case LocationMark = "f"
        case Cross = "g"
        case Check = "h"
        case Trash = "i"
        case Camera = "j"
        case LocationPin = "k"
        case ShortDownArrow = "l"
    }
}

enum TweetDetailsViewCell: String {
    case TweetAndOwnerViewCell
}