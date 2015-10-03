//
//  TwitterClient.swift
//  Twitter
//
//  Created by Amay Singhal on 9/29/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

typealias SuccessCompletionBlock = (Bool, NSError?) -> ()
typealias DataCompletionBlock = (NSDictionary?, NSError?) -> ()

class TwitterClient: BDBOAuth1RequestOperationManager {

    private struct APICredentials {
        static let ResouceName = "CredentialsInfo"
        static let TwitterConsumerKey = "ConsumerKey"
        static let TwitterConsumerSecret = "ConsumerSecret"

        static let Info: (Key: String, Secret: String) = {
            var key = "", secret = ""
            if let path = NSBundle.mainBundle().pathForResource(TwitterClient.APICredentials.ResouceName, ofType: "plist") {
                if let credentialsDictionary = NSDictionary(contentsOfFile: path) {
                    key = (credentialsDictionary[TwitterClient.APICredentials.TwitterConsumerKey] ?? "") as! String
                    secret = (credentialsDictionary[TwitterClient.APICredentials.TwitterConsumerSecret] ?? "") as! String
                }
            }
            return (key, secret)
            }()
    }

    // Twitter API dictionary keys
    struct ResponseFields {
        struct User {
            static let Name = "name"
            static let SreenName = "screen_name"
            static let ProfileImageUrlStr = "profile_image_url_https"
            static let BannerImageUrlStr = "profile_banner_url"
            static let FriendsCount = "friends_count"
            static let FollowerCount = "followers_count"
            static let FollowingCount = "following"
            static let NotificationsCount = "notifications"
            static let CreatedAt = "created_at"
        }
    }

    struct APIScheme {
        static let BaseUrl = NSURL(string: "https://api.twitter.com")
        static let OAuthRequestTokenEndpoint = "oauth/request_token"
        static let OAuthAccessTokenEndpoint = "oauth/access_token"
        static let UserCredentialEndpoint = "1.1/account/verify_credentials.json"
    }

    static let SharedInstance = TwitterClient(baseURL: APIScheme.BaseUrl, consumerKey: APICredentials.Info.Key, consumerSecret: APICredentials.Info.Secret)

    var loginCompletition: ((Bool, NSError?) -> Void)?

    static func initiateOAuthAccessRequestWithCompletion(completion: SuccessCompletionBlock?) {

        TwitterClient.SharedInstance.loginCompletition = completion

        // clean up old access token
        TwitterClient.SharedInstance.requestSerializer.removeAccessToken()

        // Get a new token
        SharedInstance.fetchRequestTokenWithPath(APIScheme.OAuthRequestTokenEndpoint, method: "GET", callbackURL: AppConstants.OAuthCallbackUrl, scope: nil, success: { (authCredential: BDBOAuth1Credential!) -> Void in
                if let  authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(authCredential.token)") {
                    UIApplication.sharedApplication().openURL(authURL)
                }
        }) { (error) -> Void in
            TwitterClient.SharedInstance.loginCompletition?(false, error)
        }
    }

    static func updateAccessTokenFromUrlQuery(query: String) {
        SharedInstance.fetchAccessTokenWithPath(APIScheme.OAuthAccessTokenEndpoint, method: "POST", requestToken: BDBOAuth1Credential(queryString: query), success: { (accessCredential: BDBOAuth1Credential!) -> Void in
                TwitterClient.SharedInstance.requestSerializer.saveAccessToken(accessCredential)
                // Call the completion block with user here
                TwitterClient.SharedInstance.loginCompletition?(true, nil)
            }) { (error) -> Void in
                // Call the completion block with error here
                TwitterClient.SharedInstance.loginCompletition?(false, error)
        }
    }

    static func fetchUserCredentialsWithCompletion(completion: DataCompletionBlock?) {

        TwitterClient.SharedInstance.GET(APIScheme.UserCredentialEndpoint, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let userCredentialsDictionary =  response as? NSDictionary
                completion?(userCredentialsDictionary, nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion?(nil, error)
        }
    }
    
}
