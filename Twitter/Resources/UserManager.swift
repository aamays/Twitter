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
        didSet(PreviousUser) {

            // check if previous user was not nil
            if let prevUser = PreviousUser {
                // clear session token
                TwitterClient.removeAccessToken()
                // set user to inactive
                prevUser.hasActiveSession = false

                if let _ = CurrentUser {
                    TwitterUser.archiveUser(prevUser)
                } else {
                    // User is set to nil
                    // remove user data from persistence
                    TwitterUser.removetUserFromArchiveWithId(prevUser.id)

                }
            }

            if let currentUser = CurrentUser {
                currentUser.hasActiveSession = true
                TwitterClient.updateAccessToken(currentUser.accessToken!)

                // archive/re-archive user
                TwitterUser.archiveUser(currentUser)
            }

        }
    }

    class func loginUserWithCompletion(completion: ((TwitterUser?, NSError?) -> Void)?) {

        TwitterClient.initiateOAuthAccessRequestWithCompletion{ (success, error) -> Void in
            if success {
                TwitterClient.fetchUserCredentialsWithCompletion({ (responseData: NSDictionary?, error: NSError?) -> () in
                    if let userCredentails = responseData {
                        UserManager.CurrentUser = TwitterUser(dictionary: userCredentails, accessToken: TwitterClient.SharedInstance.requestSerializer.accessToken, isActive: true)
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

    class func getLastActiveUser() -> TwitterUser? {
        let activeUsers = getArchivedUsers().filter { $0.hasActiveSession }
        return activeUsers.count > 0 ? activeUsers[0] : nil
    }

    class func getArchivedUsers() -> [TwitterUser] {
        let filemanager:NSFileManager = NSFileManager()
        let files = filemanager.enumeratorAtPath(AppUtils.getUserDirectory())
        print(AppUtils.getUserDirectory())
        var archivedUsers = [TwitterUser]()
        while let fileName = files?.nextObject() as? String {
            if let userId = Int(fileName) {
                if let user = NSKeyedUnarchiver.unarchiveObjectWithFile(AppUtils.getUserInfoArchiveFilePathForUserId(userId)) as? TwitterUser {
                    archivedUsers.append(user)
                }
            }
        }
        return archivedUsers
    }

    class func logoutCurrentUser() {
        CurrentUser = nil
    }
}
