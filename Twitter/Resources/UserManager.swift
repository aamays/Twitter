//
//  UserManager.swift
//  Twitter
//
//  Created by Amay Singhal on 9/30/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import CoreLocation

class UserManager: NSObject {

    static var CurrentUser: TwitterUser? {
        didSet {
            if let currentUser = CurrentUser {
                TwitterUser.archiveUser(currentUser)
                NSNotificationCenter.defaultCenter().postNotificationName(AppConstants.UserDidLoginNotification, object: nil)
            } else {
                // User is set to nil
                // remove user data from persistence
                TwitterUser.removetUserFromArchive()
                // clear session token
                TwitterClient.SharedInstance.requestSerializer.removeAccessToken()
                // send logout notification
                NSNotificationCenter.defaultCenter().postNotificationName(AppConstants.UserDidLogoutNotification, object: nil)
            }
        }
    }

    class func loginUserWithCompletion(completion: ((TwitterUser?, NSError?) -> Void)?) {

        TwitterClient.initiateOAuthAccessRequestWithCompletion{ (success, error) -> Void in
            if success {
                TwitterClient.fetchUserCredentialsWithCompletion({ (responseData: NSDictionary?, error: NSError?) -> () in
                    if let userCredentails = responseData {
                        UserManager.CurrentUser = TwitterUser(dictionary: userCredentails)
                        completion?(UserManager.CurrentUser, nil)
                    } else {
                        completion?(nil, error)
                    }
                })
            } else {
                completion?(nil, error)
            }
        }
    }

    class func updateUserStatus(status: String, inResponseToStatusId statusId: Int?, andLocation location: CLLocation?, andMediaIds mediaIds: [String]?, withCompletion completion: (Tweets?, NSError?) -> ()) {
        TwitterClient.updateStatus(status, inResponseToStatusId: statusId, andLocation: location, andMediaIds: mediaIds) { (responseData: NSDictionary?, error: NSError?) -> () in
            if let data =  responseData {
                completion(Tweets(dictionary: data), nil)
            } else {
                completion(nil, error)
            }
        }
    }

    class func deleteStatusWithId(id: Int, withCompletion completion: (Bool, NSError?) -> ()) {
        TwitterClient.deleteStatusWithId(id) { (responseData: NSDictionary?, error: NSError?) -> () in
            if let _ =  responseData {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }

    class func fetchUserTimeline(timelineType: TimelineType, withStatusId id: Int?, withOrder order: HomeTimeLineFetchOrder?, completion: ([Tweets]?, NSError?) -> ()) {

        TwitterClient.fetchUserTimelineType(timelineType, withStatusId: id, andOrder: order) { (tweetsArray:[NSDictionary]?, error: NSError?) -> () in
            if let tweetsArray = tweetsArray {
                var currentUserTweets = [Tweets]()
                for tweetInfoDict in tweetsArray {
                    let tweet = Tweets(dictionary: tweetInfoDict)
                    currentUserTweets.append(tweet)
                }
                completion(currentUserTweets, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    class func uploadMedia(media: NSData, withCompletion completion: (NSDictionary?, NSError?) -> ()) {
        TwitterClient.uploadMedia(media) { (responseData: NSDictionary?, error: NSError?) -> () in
            if let data =  responseData {
                completion(data, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    class func logoutCurrentUser() {
        CurrentUser = nil
    }
}
