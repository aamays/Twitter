//
//  TweetRepliesViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class TweetRepliesViewCell: UITableViewCell {

    var displayTweet: Tweets? {
        didSet {
            updateCellView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateCellView() {

    }

}
