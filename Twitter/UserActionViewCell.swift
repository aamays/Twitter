//
//  UserActionViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

@objc protocol UserActionViewCellDelegate: class {
    optional func userActionCellTappedRetweet(newValue: Bool)
    optional func userActionCellTappedFavorite(newValue: Bool)
    optional func userActionCellTappedReply()
}

class UserActionViewCell: UITableViewCell {

    @IBOutlet weak var replyActionButton: UIButton!
    @IBOutlet weak var retweetActionButton: UIButton!
    @IBOutlet weak var favoriteActionButton: UIButton!

    var tweet: Tweets! {
        didSet {
            updateCellView()
        }
    }

    weak var delegate: UserActionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.addBorderToViewAtPosition(.Bottom)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func replyButtonTapped(sender: UIButton) {
        delegate?.userActionCellTappedReply?()
    }

    @IBAction func retweetButtonTapped(sender: UIButton) {
        delegate?.userActionCellTappedRetweet?(!tweet.currentUserRetweeted!)
    }

    @IBAction func favoriteButtonTapped(sender: UIButton) {
        delegate?.userActionCellTappedFavorite?(!tweet.currentUserFavorited!)
    }

    private func updateCellView() {
        retweetActionButton.setTitleColor(tweet.currentUserRetweeted! ? AppConstants.Colors.Green : UIColor.darkGrayColor(), forState: .Normal)
        favoriteActionButton.setTitleColor(tweet.currentUserFavorited! ? AppConstants.Colors.FavoriteYellow : UIColor.darkGrayColor(), forState: .Normal)
    }
}
