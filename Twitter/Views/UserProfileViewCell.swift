//
//  UserProfileViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/9/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class UserProfileViewCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!

    var user: TwitterUser! {
        didSet {
            updateCellView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        profileImageView?.contentMode = .ScaleAspectFit
        profileImageView?.layer.cornerRadius = 5
        profileImageView?.clipsToBounds = true
        profileImageView?.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView?.layer.borderWidth = 2.0
        layoutMargins = UIEdgeInsetsZero
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateCellView() {
        bannerImageView?.setImageWithURL(user.profileBannerUrl)
        profileImageView?.setImageWithURL(user.profileRegularImageUrl)
    }
}
