//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/2/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsTableViewCell: UITableViewCell {

    static let Indentifier = "TweetsTableViewCell"

    // MARK: - Properties
    // MARK: Outlets
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    // MARK: Others
    static let EstimatedRowHeight = CGFloat(105)

    var tweet: Tweets! {
        didSet {
            updateUIWithTweetDetails()
        }
    }

    // MARK: - Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userProfileImageView.layer.cornerRadius = 5
        userProfileImageView.clipsToBounds = true
    }

    // MARK: - Helper methods
    private func updateUIWithTweetDetails() {
        if let tweetUser = tweet.user {
            userProfileImageView?.setImageWithURL(tweetUser.profileRegularImageUrl!)
            userNameLabel?.text = tweetUser.name!
            twitterHandleLabel?.text = tweetUser.stylizedScreenName!
        }
        tweetTextLabel?.text = tweet.text!
        if let date = tweet.createdAt {
            timeElapsedLabel?.text = DateUtils.getTimeElapsedSinceDate(date)
        }

    }

}
