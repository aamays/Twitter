//
//  TweetTimeStampViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class TweetTimeStampViewCell: UITableViewCell {

    var tweetDate: NSDate! {
        didSet {
            updateViewForCell()
        }
    }

    @IBOutlet weak var timestampLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.addBorderToViewAtPosition(.Bottom)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateViewForCell() {
        timestampLabel?.text = DateUtils.getPresentationDateString(tweetDate)
    }
}
