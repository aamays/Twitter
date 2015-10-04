//
//  UserManager.swift
//  Twitter
//
//  Created by Amay Singhal on 9/30/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

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

    class func updateUserStatus(status: String, inResponseToStatusId statusId: Int?, withCompletion completion: (Bool, NSError?) -> ()) {
        TwitterClient.updateStatus(status, inResponseToStatusId: statusId) { (responseData: NSDictionary?, error: NSError?) -> () in
            if error == nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }

    class func logoutCurrentUser() {
        CurrentUser = nil
    }
}
