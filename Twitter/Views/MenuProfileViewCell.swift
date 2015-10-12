//
//  MenuProfileViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/8/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class MenuProfileViewCell: UITableViewCell {

    @IBOutlet weak var menuProfileImageView: UIImageView!
    @IBOutlet weak var menuProfileUserName: UILabel!
    @IBOutlet weak var menuProfileScreenName: UILabel!

    var user: TwitterUser! {
        didSet {
            setupUI()
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

    private func setupUI() {
        // table profile image view
        menuProfileImageView?.contentMode = .ScaleAspectFit
        menuProfileImageView?.layer.cornerRadius = 5
        menuProfileImageView?.clipsToBounds = true

        menuProfileImageView?.setImageWithURL(user.profileRegularImageUrl)

        // set name label
        menuProfileUserName.text = user.name
        menuProfileScreenName.text = user.stylizedScreenName
    }

}
