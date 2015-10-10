//
//  AppConstants.swift
//  Twitter
//
//  Created by Amay Singhal on 9/30/15.
//  Copyright © 2015 ple. All rights reserved.
//

import Foundation
import UIKit



enum TweetDetailsViewCell: String {
    case TweetAndOwnerViewCell, TweetMediaViewCell, TweetTimeStampViewCell, TweetMeasuresViewCell, UserActionViewCell, TweetRepliesViewCell
}

enum TwitterMediaTypes: String {
    case photo
}

enum BorderPotion {
    case Top, Bottom
}

enum TweetMeasures {
    case Retweet, Favorite
}

enum MenuViewCellType: String {
    case MenuProfileViewCell, MenuOptionViewCell
}


enum TimelineType {
    case Home, Mentions
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
        case AddUser = "m"
        case MoreOptions = "n"
        case TwitterBirdCircled = "o"
        case TwitterBird = "p"
        case CheckCircled = "q"
        case LoginDoor = "r"
        case PowerOff = "s"
        case Switch = "t"
        case UserFilled = "u"
        case UserEmpty = "v"
        case Home = "w"
        case Menu = "x"
        case AtSign = "y"
    }
}
typealias FontasticIconType = FontasticIcons.Map

struct AppConstants {
    static let UserDidLoginNotification = "info.amays.UserDidLoginNotification"
    static let UserDidLogoutNotification = "info.amays.UserDidLogoutNotificationKey"

    static let OAuthCallbackUrl = NSURL(string: "aktwitter://oauth")

    static let UserInfoArchiveFilename = "userinfoarchive"

    static let TwitterBlueColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1)
    static let ApplicationBarTintColor = UIColor.whiteColor()

    struct MainStoryboard {
        static let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        static let ShowHomeTimelineSegueIdentifier = "Show Home Timeline"
        static let TimelineVCIdentifier = "TimelineViewController"
        static let TwitterLoginVCIdentifier = "TwitterLoginViewController"
        static let TimelineNavVCIdentifier = "TimelineNavigationViewController"
        static let TweetComposerVCIdentifier = "TweetComposerViewController"
        static let UserProfileVCIdentifier = "UserProfileViewController"
        static let ManagerVCIdentifier = "VCMangerViewController"
        static let MenuVCIdentifier = "MenuViewController"
        static let ProfileVCIndetifier = "ProfileViewController"
        static let ComposeReplySegueIdentifier = "Compose Reply"
        static let ShowFullImageSegueIdentifier = "Show Full Image"
        static let ComposeNewStatusSegueIndentifier = "Compose New Status"
    }

    struct Colors {
        static let Green = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        static let FavoriteYellow = UIColor(red: 255/255, green: 180/255, blue: 30/255, alpha: 1)
        static let TwitterBlueColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1)
        static let LocationActivePinColor = UIColor(red: 228/255, green: 48/255, blue: 26/255, alpha: 1)
        static let MediaActiveIconColor = UIColor(red: 128/255, green: 64/255, blue: 23/255, alpha: 1)
        static let LightBorderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
    }
}
typealias MainStoryboard = AppConstants.MainStoryboard
