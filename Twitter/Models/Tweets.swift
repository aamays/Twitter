//
//  Tweets.swift
//  Twitter
//
//  Created by Amay Singhal on 10/2/15.
//  Copyright © 2015 ple. All rights reserved.
//  Twitter User JSON fields:
//    text = "PHOTOS: Under 40 on the #Forbes400: http://t.co/whOpd1vSyh http://t.co/U9YAI4BfqN";
//    "retweet_count" = 21;
//    retweeted = 0;
//    user =     { ... }
//    "favorite_count" = 19;
//    favorited = 0;

import UIKit

class Tweets: NSObject {

    var id: Int?
    var text: String?
    var user: TwitterUser?
    var createdAt: NSDate?

    var retweetCount: Int?
    var currentUserRetweeted: Bool?
    var retweetId: Int?

    var favoriteCount: Int?
    var currentUserFavorited: Bool?


    init(dictionary: NSDictionary) {

        id = dictionary[TwitterClient.ResponseFields.Tweet.Id] as? Int

        text = dictionary[TwitterClient.ResponseFields.Tweet.Text] as? String
        if let userInfoDict = dictionary[TwitterClient.ResponseFields.Tweet.User] as? NSDictionary {
            user = TwitterUser(dictionary: userInfoDict)
        }

        if let dateString = dictionary[TwitterClient.ResponseFields.Tweet.CreatedAt] as? String {
            DateUtils.DateFormatter.dateFormat = DateUtils.TwitterApiResponseDateFormat
            createdAt = DateUtils.DateFormatter.dateFromString(dateString)
        }

        // set retweeted properties
        retweetCount = dictionary[TwitterClient.ResponseFields.Tweet.RetweetCount] as? Int
        currentUserRetweeted = (dictionary[TwitterClient.ResponseFields.Tweet.Retweeted] as! Bool)

        // set favorited properties
        favoriteCount = dictionary[TwitterClient.ResponseFields.Tweet.FavoriteCount] as? Int
        currentUserFavorited = (dictionary[TwitterClient.ResponseFields.Tweet.Favorited] as! Bool)

    }

    // MARK: - Instance methods
    func updateRetweetWithCompletion(completion: (Bool, NSError?) -> ()) {
        let statusId = self.currentUserRetweeted! ? id! : retweetId!
        TwitterClient.updateTweetStatusWitId(statusId, status: currentUserRetweeted!) { (responseData: NSDictionary?, error: NSError?) -> () in
            if let error = error {
                completion(false, error)
            } else {
                self.retweetId = responseData?[TwitterClient.ResponseFields.Retweet.Id] as? Int
                completion(true, error)
            }
        }
    }

    func toggleFavoriteStatusWithCompletion(completion: (Bool, NSError?) -> ()) {
        TwitterClient.updateFavoriteStatusWitId(id!, status: currentUserFavorited!) { (responseData: NSDictionary?, error: NSError?) -> () in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, error)
            }
        }
    }

    func updateRetweetId() {
        // @todo: somehow updated the retweet id
        retweetId = id
    }

    // MARK: - Class type methods
    class func getCurrentUserTweetsWithCompletion(completion: ([Tweets]?, NSError?) -> ()) {
        TwitterClient.fetchUserTweetsWithCompletion { (tweetsArray:[NSDictionary]?, error: NSError?) -> () in
            if let tweetsArray = tweetsArray {
                var currentUserTweets = [Tweets]()
                for tweetInfoDict in tweetsArray {
                    let tweet = Tweets(dictionary: tweetInfoDict)
                    tweet.currentUserRetweeted! ? tweet.updateRetweetId() : ()
                    currentUserTweets.append(tweet)
                }
                completion(currentUserTweets, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
