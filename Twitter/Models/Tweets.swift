//
//  Tweets.swift
//  Twitter
//
//  Created by Amay Singhal on 10/2/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class Tweets: NSObject {

    var text: String?
    var user: TwitterUser?
    var createdAt: NSDate?

    init(dictionary: NSDictionary) {
        text = dictionary[TwitterClient.ResponseFields.Tweet.Text] as? String
        if let userInfoDict = dictionary[TwitterClient.ResponseFields.Tweet.User] as? NSDictionary {
            user = TwitterUser(dictionary: userInfoDict)
        }

        if let dateString = dictionary[TwitterClient.ResponseFields.Tweet.CreatedAt] as? String {
            DateUtils.DateFormatter.dateFormat = DateUtils.TwitterApiResponseDateFormat
            createdAt = DateUtils.DateFormatter.dateFromString(dateString)
        }
    }

    class func getCurrentUserTweetsWithCompletion(completion: ([Tweets]?, NSError?) -> ()) {
        TwitterClient.fetchUserTweetsWithCompletion { (tweetsArray:[NSDictionary]?, error: NSError?) -> () in
            if let tweetsArray = tweetsArray {
                var currentUserTweets = [Tweets]()
                for tweetInfoDict in tweetsArray {
                    currentUserTweets.append(Tweets(dictionary: tweetInfoDict))
                }
                completion(currentUserTweets, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
