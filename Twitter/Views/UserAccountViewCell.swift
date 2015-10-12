//
//  UserAccountViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/11/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class UserAccountViewCell: UICollectionViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!

    var user: TwitterUser! {
        didSet {
            updateViewCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // add gesture event here
        userImageView?.layer.cornerRadius = 5
        userImageView?.clipsToBounds = true
        userImageView?.layer.borderColor = UIColor.whiteColor().CGColor
        userImageView?.layer.borderWidth = 3.0

    }

    private func updateViewCell() {
        userImageView.setImageWithURL(user.profileRegularImageUrl)
        usernameLabel.text = user.name
        screenNameLabel.text = user.stylizedScreenName
        userImageView?.layer.borderColor = user.hasActiveSession ? AppConstants.Colors.TwitterBlueColor.CGColor : UIColor.whiteColor().CGColor
    }
}
