//
//  User.swift
//  Twitter
//
//  Created by Amay Singhal on 9/30/15.
//  Copyright © 2015 ple. All rights reserved.
//
//  Twitter User JSON fields:
//    "followers_count" = 4;
//    following = 0;
//    "friends_count" = 22;
//    name = "Amay Singhal";
//    notifications = 0;
//    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/648746799440658432/3ij3HWpR_normal.jpg";
//    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/3722851884/1443508649";
//    "screen_name" = "_asinghal";
//    "created_at" = "Tue Sep 29 06:27:41 +0000 2015";
import UIKit
import BDBOAuth1Manager

class TwitterUser: NSObject, NSCoding {

    var id: Int!
    var name: String?
    var screenName: String?
    var stylizedScreenName: String? {
        if let sName = screenName {
            return "@\(sName)"
        }
        return nil
    }

    var userDescription: String?

    var profileSmallImageUrl: NSURL?
    var profileRegularImageUrl: NSURL? {
        var profileSmallImgUrlString = profileSmallImageUrl?.absoluteString ?? ""
        let range = profileSmallImgUrlString.rangeOfString("_normal", options: .LiteralSearch)
        if let range = range {
            profileSmallImgUrlString = profileSmallImgUrlString.stringByReplacingCharactersInRange(range, withString: "_bigger")
        }
        return NSURL(string: profileSmallImgUrlString)
    }
    var profileBannerUrl: NSURL?

    var friendsCount: Int?
    var followerCount: Int?
    var followingCount: Int?
    var statusCounts: Int?

    var notificationsCount: Int?
    var createdAt: NSDate?

    var isVerified = false

    // theme color variables
    var profileLinkColor: UIColor?
    var profileSidebarBorderColor: UIColor?
    var profileSidebarFillColor: UIColor?
    var profileTextColor: UIColor?

    // user access token (only applicable for logged in users and not the tweet user)
    var accessToken: BDBOAuth1Credential?
    static let AccessTokenArchiveKey = "access_token"

    // check user state
    var hasActiveSession = false
    static let HasActiveSessionArchiveKey = "has_active_session"

    init(dictionary: NSDictionary, accessToken token: BDBOAuth1Credential? = nil, isActive active: Bool = false) {

        id = dictionary[TwitterClient.ResponseFields.User.Id] as! Int

        name = dictionary[TwitterClient.ResponseFields.User.Name] as? String
        screenName = dictionary[TwitterClient.ResponseFields.User.SreenName] as? String
        userDescription = dictionary[TwitterClient.ResponseFields.User.Description] as? String
        notificationsCount = dictionary[TwitterClient.ResponseFields.User.NotificationsCount] as? Int
        friendsCount = dictionary[TwitterClient.ResponseFields.User.FriendsCount] as? Int
        followerCount = dictionary[TwitterClient.ResponseFields.User.FollowerCount] as? Int
        followingCount = dictionary[TwitterClient.ResponseFields.User.FollowingCount] as? Int
        statusCounts = dictionary[TwitterClient.ResponseFields.User.StatusesCount] as? Int

        if let profileImageUrl = dictionary[TwitterClient.ResponseFields.User.ProfileImageUrlStr] as? String {
            profileSmallImageUrl = NSURL(string: profileImageUrl)
        }

        if let bannerImageUrl = dictionary[TwitterClient.ResponseFields.User.BannerImageUrlStr] as? String {
            profileBannerUrl = NSURL(string: bannerImageUrl)
        }

        if let dateString = dictionary[TwitterClient.ResponseFields.User.CreatedAt] as? String {
            DateUtils.DateFormatter.dateFormat = DateUtils.TwitterApiResponseDateFormat
            createdAt = DateUtils.DateFormatter.dateFromString(dateString)
        }

        if let verified = dictionary[TwitterClient.ResponseFields.User.Verified] as? Bool {
            isVerified = verified
        }

        // set colors
        if let profileLinkColorHex = dictionary[TwitterClient.ResponseFields.User.ProfileLinkColor] as? String {
            profileLinkColor = UIColor(colorCode: profileLinkColorHex, alpha: 1)
        }

        if let profileSidebarBorderColorHex = dictionary[TwitterClient.ResponseFields.User.ProfileSidebarBorderColor] as? String {
            profileSidebarBorderColor = UIColor(colorCode: profileSidebarBorderColorHex, alpha: 1)
        }

        if let profileSidebarFillColorHex = dictionary[TwitterClient.ResponseFields.User.ProfileSidebarFillColor] as? String {
            profileSidebarFillColor = UIColor(colorCode: profileSidebarFillColorHex, alpha: 1)
        }

        if let profileTextColorColorHex = dictionary[TwitterClient.ResponseFields.User.ProfileTextColor] as? String {
            profileTextColor = UIColor(colorCode: profileTextColorColorHex, alpha: 1)
        }

        accessToken = token

        hasActiveSession = active
    }

    // MARK: - NSCoding methods
    required convenience init?(coder aDecoder: NSCoder) {
        let userDetailsDictionary = NSMutableDictionary()
        userDetailsDictionary.setValue(aDecoder.decodeIntegerForKey(TwitterClient.ResponseFields.User.Id), forKey: TwitterClient.ResponseFields.User.Id)
        userDetailsDictionary.setValue(aDecoder.decodeObjectForKey(TwitterClient.ResponseFields.User.Name) as? String, forKey: TwitterClient.ResponseFields.User.Name)
        userDetailsDictionary.setValue(aDecoder.decodeObjectForKey(TwitterClient.ResponseFields.User.SreenName) as? String, forKey: TwitterClient.ResponseFields.User.SreenName)
        userDetailsDictionary.setValue(aDecoder.decodeObjectForKey(TwitterClient.ResponseFields.User.Description) as? String, forKey: TwitterClient.ResponseFields.User.Description)

        // user stats
        userDetailsDictionary.setValue(aDecoder.decodeIntegerForKey(TwitterClient.ResponseFields.User.FriendsCount), forKey: TwitterClient.ResponseFields.User.FriendsCount)
        userDetailsDictionary.setValue(aDecoder.decodeIntegerForKey(TwitterClient.ResponseFields.User.FollowerCount), forKey: TwitterClient.ResponseFields.User.FollowerCount)
        userDetailsDictionary.setValue(aDecoder.decodeIntegerForKey(TwitterClient.ResponseFields.User.FollowingCount), forKey: TwitterClient.ResponseFields.User.FollowingCount)
        userDetailsDictionary.setValue(aDecoder.decodeIntegerForKey(TwitterClient.ResponseFields.User.NotificationsCount), forKey: TwitterClient.ResponseFields.User.NotificationsCount)
        userDetailsDictionary.setValue(aDecoder.decodeIntegerForKey(TwitterClient.ResponseFields.User.StatusesCount), forKey: TwitterClient.ResponseFields.User.StatusesCount)

        userDetailsDictionary.setValue(aDecoder.decodeObjectForKey(TwitterClient.ResponseFields.User.ProfileImageUrlStr) as? String, forKey: TwitterClient.ResponseFields.User.ProfileImageUrlStr)
        userDetailsDictionary.setValue(aDecoder.decodeObjectForKey(TwitterClient.ResponseFields.User.BannerImageUrlStr) as? String, forKey: TwitterClient.ResponseFields.User.BannerImageUrlStr)

        userDetailsDictionary.setValue(aDecoder.decodeObjectForKey(TwitterClient.ResponseFields.User.CreatedAt) as? String, forKey: TwitterClient.ResponseFields.User.CreatedAt)

        // colors
        userDetailsDictionary.setValue(aDecoder.decodeObjectForKey(TwitterClient.ResponseFields.User.ProfileLinkColor) as? UIColor, forKey: TwitterClient.ResponseFields.User.ProfileLinkColor)
        userDetailsDictionary.setValue(aDecoder.decodeObjectForKey(TwitterClient.ResponseFields.User.ProfileSidebarBorderColor) as? UIColor, forKey: TwitterClient.ResponseFields.User.ProfileSidebarBorderColor)
        userDetailsDictionary.setValue(aDecoder.decodeObjectForKey(TwitterClient.ResponseFields.User.ProfileSidebarFillColor) as? UIColor, forKey: TwitterClient.ResponseFields.User.ProfileSidebarFillColor)
        userDetailsDictionary.setValue(aDecoder.decodeObjectForKey(TwitterClient.ResponseFields.User.ProfileTextColor) as? UIColor, forKey: TwitterClient.ResponseFields.User.ProfileTextColor)

        let activeSession = aDecoder.decodeBoolForKey(TwitterUser.HasActiveSessionArchiveKey)

        let token = aDecoder.decodeObjectForKey(TwitterUser.AccessTokenArchiveKey) as? BDBOAuth1Credential
        self.init(dictionary: userDetailsDictionary, accessToken: token, isActive: activeSession)
    }

    func encodeWithCoder(aCoder: NSCoder) {

        aCoder.encodeInteger(id, forKey: TwitterClient.ResponseFields.User.Id)
        aCoder.encodeObject(name, forKey: TwitterClient.ResponseFields.User.Name)
        aCoder.encodeObject(screenName, forKey: TwitterClient.ResponseFields.User.SreenName)
        aCoder.encodeObject(userDescription, forKey: TwitterClient.ResponseFields.User.Description)
        aCoder.encodeInteger(friendsCount!, forKey: TwitterClient.ResponseFields.User.FriendsCount)
        aCoder.encodeInteger(followerCount!, forKey: TwitterClient.ResponseFields.User.FollowerCount)
        aCoder.encodeInteger(followingCount!, forKey: TwitterClient.ResponseFields.User.FollowingCount)
        aCoder.encodeInteger(notificationsCount!, forKey: TwitterClient.ResponseFields.User.NotificationsCount)
        aCoder.encodeInteger(statusCounts!, forKey: TwitterClient.ResponseFields.User.StatusesCount)

        aCoder.encodeObject(profileSmallImageUrl?.absoluteString, forKey: TwitterClient.ResponseFields.User.ProfileImageUrlStr)
        aCoder.encodeObject(profileBannerUrl?.absoluteString, forKey: TwitterClient.ResponseFields.User.BannerImageUrlStr)

        DateUtils.DateFormatter.dateFormat = DateUtils.TwitterApiResponseDateFormat
        aCoder.encodeObject(DateUtils.DateFormatter.stringFromDate(createdAt!), forKey: TwitterClient.ResponseFields.User.CreatedAt)

        aCoder.encodeObject(profileLinkColor, forKey: TwitterClient.ResponseFields.User.ProfileLinkColor)
        aCoder.encodeObject(profileSidebarBorderColor, forKey: TwitterClient.ResponseFields.User.ProfileSidebarBorderColor)
        aCoder.encodeObject(profileSidebarFillColor, forKey: TwitterClient.ResponseFields.User.ProfileSidebarFillColor)
        aCoder.encodeObject(profileTextColor, forKey: TwitterClient.ResponseFields.User.ProfileTextColor)

        // save access token
        aCoder.encodeObject(accessToken, forKey: TwitterUser.AccessTokenArchiveKey)
        aCoder.encodeBool(hasActiveSession, forKey: TwitterUser.HasActiveSessionArchiveKey)
    }

    // MARK: - Class Type methods
    class func archiveUser(user: TwitterUser) -> Bool {
        return NSKeyedArchiver.archiveRootObject(user, toFile: AppUtils.getUserInfoArchiveFilePathForUserId(user.id))
    }

    class func getUserFromArchiveWithId(id: Int) -> TwitterUser? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(AppUtils.getUserInfoArchiveFilePathForUserId(id)) as? TwitterUser
    }

    class func removetUserFromArchiveWithId(id: Int) -> Bool {
        if let _ = try? (NSFileManager.defaultManager().removeItemAtPath(AppUtils.getUserInfoArchiveFilePathForUserId(id))) { return true }
        return false
    }

}
