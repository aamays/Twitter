//
//  TwitterClient.swift
//  Twitter
//
//  Created by Amay Singhal on 9/29/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import CoreLocation

typealias SuccessCompletionBlock = (Bool, NSError?) -> ()
typealias DictionaryDataCompletionBlock = (NSDictionary?, NSError?) -> ()
typealias ArrayDataCompletionBlock = ([NSDictionary]?, NSError?) -> ()

enum HomeTimeLineFetchOrder: String {
    case Since = "since_id"
    case Before = "max_id"
}

class TwitterClient: BDBOAuth1RequestOperationManager {

    static let FetchResultsCount = 20

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
            static let Id = "id"
            static let Name = "name"
            static let SreenName = "screen_name"
            static let ProfileImageUrlStr = "profile_image_url_https"
            static let BannerImageUrlStr = "profile_banner_url"
            static let FriendsCount = "friends_count"
            static let FollowerCount = "followers_count"
            static let FollowingCount = "following"
            static let NotificationsCount = "notifications"
            static let CreatedAt = "created_at"
            static let Verified = "verified"
        }

        struct Tweet {
            static let Id = "id"
            static let Text = "text"
            static let User = "user"
            static let CreatedAt = "created_at"
            static let RetweetCount = "retweet_count"
            static let Retweeted = "retweeted"
            static let FavoriteCount = "favorite_count"
            static let Favorited = "favorited"
            static let RetweetStatus = "retweet_status"
            struct RetweetStatusInfo {
                static let Id = "id"
            }
            static let Entities = "entities"
            static let EntitiesMedia = "media"
            static let EntitiesMediaHttpsUrl = "media_url_https"
            static let EntitiesMediaType = "type"
        }

        struct Retweet {
            static let Id = "id"
            static let RetweetStatus = "retweeted_status"
            struct RetweetStatusInfo {
                static let Id = "id"
            }
        }

        struct ShowTweet {
            static let CurrentUserRetweet = "current_user_retweet"
            static let CurrentUserRetweetId = "id"
        }
    }

    struct RequestFields {
        static let StatusHomeTimelineCount = "count"
        static let StatusHomeTimelineMaxId = "max_id"
        static let ShowStatusIncludeMyTweet = "include_my_retweet"
    }

    struct APIScheme {
        static let BaseUrl = NSURL(string: "https://api.twitter.com")
        static let UploadUrl = NSURL(string: "https://upload.twitter.com")

        static let OAuthRequestTokenEndpoint = "oauth/request_token"
        static let OAuthAccessTokenEndpoint = "oauth/access_token"
        static let UserCredentialEndpoint = "1.1/account/verify_credentials.json"
        static let HomeTimelineEndpoint = "1.1/statuses/home_timeline.json"
        static let ShowStatusEndpoint = "1.1/statuses/show/:id.json"
        static let UpdateStatusEndpoint = "1.1/statuses/update.json"
        static let RetweetStatusEndpoint = "1.1/statuses/retweet/:id.json"
        static let RetweetsOfStatusEndpoint = "1.1/statuses/retweets/:id.json"
        static let DestroyStatusEndpoint = "1.1/statuses/destroy/:id.json"
        static let FavoriteCreateEndpoint = "1.1/favorites/create.json"
        static let FavoriteDestroyEndpoint = "1.1/favorites/destroy.json"
        static let MediaUploadEndpoint = "1.1/media/upload.json"
    }

    static let SharedInstance = TwitterClient(baseURL: APIScheme.BaseUrl, consumerKey: APICredentials.Info.Key, consumerSecret: APICredentials.Info.Secret)
    static let ShareUploadInstace = TwitterClient(baseURL: APIScheme.UploadUrl, consumerKey: APICredentials.Info.Key, consumerSecret: APICredentials.Info.Secret)

    var loginCompletition: ((Bool, NSError?) -> Void)?

    static func initiateOAuthAccessRequestWithCompletion(completion: SuccessCompletionBlock?) {

        TwitterClient.SharedInstance.loginCompletition = completion

        // clean up old access token
        TwitterClient.SharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.ShareUploadInstace.requestSerializer.removeAccessToken()

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
                TwitterClient.ShareUploadInstace.requestSerializer.saveAccessToken(accessCredential)
                // Call the completion block with user here
                TwitterClient.SharedInstance.loginCompletition?(true, nil)
            }) { (error) -> Void in
                // Call the completion block with error here
                TwitterClient.SharedInstance.loginCompletition?(false, error)
        }
    }

    static func fetchUserCredentialsWithCompletion(completion: DictionaryDataCompletionBlock?) {

        TwitterClient.SharedInstance.GET(APIScheme.UserCredentialEndpoint, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let userCredentialsDictionary =  response as? NSDictionary
                completion?(userCredentialsDictionary, nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion?(nil, error)
        }
    }

    static func fetchUserTweetsWithCompletion(id: Int?, withOrder order: HomeTimeLineFetchOrder?, completion: ArrayDataCompletionBlock?) {
        let parameters = NSMutableDictionary()
        parameters[RequestFields.StatusHomeTimelineCount] = FetchResultsCount
        if let id = id, let order = order {
            parameters[order.rawValue] = id
        }

        print(parameters)
        TwitterClient.SharedInstance.GET(APIScheme.HomeTimelineEndpoint, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let userTweets =  response as? [NSDictionary]
            completion?(userTweets, nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error.localizedDescription)
                completion?(nil, error)
        }
    }

    static func fetchRetweetsOfStatusWithId(id: Int, andCompletion completion: DictionaryDataCompletionBlock?) {
        let endpoint = replaceIdInTwitterEndpointString(APIScheme.ShowStatusEndpoint, id: id)
        let parameters = NSMutableDictionary()
        parameters[RequestFields.ShowStatusIncludeMyTweet] = 1
        TwitterClient.SharedInstance.GET(endpoint, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweetStatus =  response as? NSDictionary
            completion?(tweetStatus, nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error.localizedDescription)
                completion?(nil, error)
        }
    }

    static func updateTweetStatusWitId(id: Int, status: Bool, WithCompletion completion: DictionaryDataCompletionBlock?) {
        var useEndpoint = status ? APIScheme.RetweetStatusEndpoint : APIScheme.DestroyStatusEndpoint
        useEndpoint = replaceIdInTwitterEndpointString(useEndpoint, id: id)

        TwitterClient.SharedInstance.POST(useEndpoint, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let retweetResponse =  response as? NSDictionary
            completion?(retweetResponse, nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error.localizedDescription)
                completion?(nil, error)
        }
    }

    private static func replaceIdInTwitterEndpointString(var endpointString: String, id: Int) -> String {
        let range = endpointString.rangeOfString(":id", options: .LiteralSearch)
        if let range = range {
            endpointString = endpointString.stringByReplacingCharactersInRange(range, withString: "\(id)")
        }
        return endpointString
    }

    static func updateFavoriteStatusWitId(id: Int, status: Bool, WithCompletion completion: DictionaryDataCompletionBlock?) {
        let useEndpoint = status ? APIScheme.FavoriteCreateEndpoint : APIScheme.FavoriteDestroyEndpoint
        TwitterClient.SharedInstance.POST(useEndpoint, parameters: ["id": id], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let retweetResponse =  response as? NSDictionary
            completion?(retweetResponse, nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion?(nil, error)
        }
    }

    static func updateStatus(status: String, inResponseToStatusId replyStatusId: Int?, andLocation location: CLLocation?, withCompletion completion: DictionaryDataCompletionBlock?) {
        let parameters = NSMutableDictionary()
        parameters["status"] = status
        if let replyStatusId = replyStatusId {
            parameters["in_reply_to_status_id"] = replyStatusId
        }

        if let currLocation = location {
            parameters["lat"] = currLocation.coordinate.latitude
            parameters["long"] = currLocation.coordinate.longitude
            parameters["display_coordinates"] = true
        }

        TwitterClient.SharedInstance.POST(APIScheme.UpdateStatusEndpoint, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let retweetResponse =  response as? NSDictionary

            completion?(retweetResponse, nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error.localizedDescription)
                completion?(nil, error)
        }
    }

    static func uploadMedia(media: NSData, withCompletion completion: DictionaryDataCompletionBlock?) {
        TwitterClient.ShareUploadInstace.POST(APIScheme.MediaUploadEndpoint, parameters: nil, constructingBodyWithBlock: { (data: AFMultipartFormData!) -> Void in
            data.appendPartWithFormData(media, name: "media")
            }, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let uploadResponse =  response as? NSDictionary
            print(uploadResponse)
            completion?(uploadResponse, nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error.localizedDescription)
                completion?(nil, error)
        }
    }

    static func deleteStatusWithId(id: Int, withCompletion completion: DictionaryDataCompletionBlock?) {
        let destroyWithIdEndpoint = replaceIdInTwitterEndpointString(APIScheme.DestroyStatusEndpoint, id: id)
        TwitterClient.SharedInstance.POST(destroyWithIdEndpoint, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let retweetResponse =  response as? NSDictionary
            completion?(retweetResponse, nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion?(nil, error)
        }
    }
}
