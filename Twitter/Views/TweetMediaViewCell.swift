//
//  TweetMediaViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class TweetMediaViewCell: UITableViewCell {

    var mediaUrl: NSURL! {
        didSet {
            tweetMediaImageView?.setImageWithURL(mediaUrl)
        }
    }

    @IBOutlet weak var tweetMediaImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Initialization code
        tweetMediaImageView.layer.cornerRadius = 5
        tweetMediaImageView.clipsToBounds = true
        tweetMediaImageView.contentMode = .ScaleAspectFit
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
