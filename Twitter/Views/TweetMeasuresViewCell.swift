//
//  TweetMeasuresViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class TweetMeasuresViewCell: UITableViewCell {

    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!

    var tweet: Tweets! {
        didSet {
            updateCellUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.addBorderToViewAtPosition(.Bottom)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateCellUI() {
        retweetCountLabel.text = NumberUtils.getDecimalFormattedNumberString(NSNumber(integer: tweet.retweetCount!))
        favoriteCountLabel.text = NumberUtils.getDecimalFormattedNumberString(NSNumber(integer: tweet.favoriteCount!))
    }

}
