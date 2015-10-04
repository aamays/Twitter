//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/2/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol TweetsTableViewCellDelegate: class {
    optional func tweetCellFavoritedDidToggle(cell: TweetsTableViewCell, newValue: Bool)
    optional func tweetCellRetweetDidToggle(cell: TweetsTableViewCell, newValue: Bool)
    optional func tweetCellDeleteStatus(cell: TweetsTableViewCell, withId id: Int)
}

class TweetsTableViewCell: UITableViewCell {

    static let Indentifier = "TweetsTableViewCell"

    // MARK: - Properties
    // MARK: Outlets
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favoriteTweetButton: UIButton!
    @IBOutlet weak var deleteTweetButton: UIButton!


    // MARK: Others
    static let EstimatedRowHeight = CGFloat(130)

    var tweet: Tweets! {
        didSet {
            updateUIWithTweetDetails()
        }
    }

    var cellIndex: Int? {
        didSet {
            retweetButton?.tag = cellIndex!
            replyButton?.tag = cellIndex!
            favoriteTweetButton?.tag = cellIndex!
            deleteTweetButton?.tag = cellIndex!
        }
    }

    weak var delegate: TweetsTableViewCellDelegate?

    var retweetAttributedText: NSAttributedString {
        return getAttributedTextForActionButtons(tweet.retweetCount, userStatus: tweet.currentUserRetweeted, iconType: .Retweet, activeColor: AppConstants.Colors.Green)
    }

    var favoriteAttributedText: NSAttributedString {
        return getAttributedTextForActionButtons(tweet.favoriteCount, userStatus: tweet.currentUserFavorited, iconType: .StarFilled, activeColor: AppConstants.Colors.FavoriteYellow)
    }

    struct CellViewConstants {
        static let BaselineOffsetWithText = CGFloat(-3)
        static let BaselineOffsetWithoutText = CGFloat(-1)
    }
    // MARK: - Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userProfileImageView.layer.cornerRadius = 5
        userProfileImageView.clipsToBounds = true

    }

    // MARK: - View actions
    @IBAction func replyButtonTapped(sender: UIButton) {
        // @todo: Present a modal view to post a reply
    }

    @IBAction func retweetButtonTapped(sender: UIButton) {
        // update tweet retweet status
        delegate?.tweetCellRetweetDidToggle?(self, newValue: !tweet.currentUserRetweeted!)
    }

    @IBAction func favoriteTweetButtonTapped(sender: UIButton) {
        // update tweet favorite status
        delegate?.tweetCellFavoritedDidToggle?(self, newValue: !tweet.currentUserFavorited!)
    }

    @IBAction func deleteTweetButton(sender: UIButton) {
        delegate?.tweetCellDeleteStatus?(self, withId: tweet.id!)
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


        retweetButton?.setAttributedTitle(retweetAttributedText, forState: UIControlState.Normal)
        favoriteTweetButton?.setAttributedTitle(favoriteAttributedText, forState: UIControlState.Normal)

        deleteTweetButton.alpha = (tweet?.user?.screenName == UserManager.CurrentUser?.screenName) ? 1 : 0
    }

    private func getAttributedTextForActionButtons(count: Int?, userStatus: Bool?, iconType: FontasticIconType, activeColor: UIColor) -> NSAttributedString {
        var countString = ""
        var baseLineOffset = CellViewConstants.BaselineOffsetWithoutText
        if let count = count {
            if count > 0 {
                countString = "\(count)"
                baseLineOffset = CellViewConstants.BaselineOffsetWithText
            }
        }

        let iconColor = (userStatus ?? false) ? activeColor : UIColor.darkGrayColor()
        return AppUtils.getAttributedStringForActionButtons(countString, icon: iconType, iconTextColor: iconColor, andBaseLine: baseLineOffset)
    }

}
