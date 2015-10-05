//
//  TweetAndOwnerViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class TweetAndOwnerViewCell: UITableViewCell {

    static let EstimatedRowHeight = CGFloat(100)
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetOwnerNameLabel: UILabel!
    @IBOutlet weak var tweetOwnerScreennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var ownerVerifiedLabel: UILabel!

    var tweet: Tweets! {
        didSet {
            updateCellWithTweetInfo()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        // Initialization code
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .ScaleAspectFit
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateCellWithTweetInfo() {
        profileImageView.setImageWithURL(tweet.user?.profileRegularImageUrl)
        tweetOwnerNameLabel.text = tweet.user?.name
        tweetOwnerScreennameLabel?.text = tweet.user?.stylizedScreenName
        tweetTextLabel?.text = tweet.text
        ownerVerifiedLabel.alpha = (tweet.user?.isVerified)! ? 1 : 0
    }
}
