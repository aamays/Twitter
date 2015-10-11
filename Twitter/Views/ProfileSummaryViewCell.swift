//
//  ProfileSummaryViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/11/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class ProfileSummaryViewCell: UITableViewCell {

    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!

    struct CellConstants {
        static let BorderCellColor = UIColor.lightGrayColor()
    }

    var user: TwitterUser! {
        didSet {
            setupCellView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.addBorderToViewAtPosition(.Bottom, color: CellConstants.BorderCellColor, andThickness: 0.5)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupCellView() {
        tweetCountLabel.text = NumberUtils.getDecimalFormattedNumberString(NSNumber(integer: user.statusCounts!))
        followerCountLabel.text = NumberUtils.getDecimalFormattedNumberString(NSNumber(integer: user.followerCount!))
        followingCountLabel.text = NumberUtils.getDecimalFormattedNumberString(NSNumber(integer: user.friendsCount!))
    }
}
