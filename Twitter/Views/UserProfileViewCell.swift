//
//  UserProfileViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/9/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

@objc protocol UserProfileViewCellDelegate: class {
    optional func userProfileViewCellDidStartSummaryScroll(userProfileViewCell: UserProfileViewCell, withAnimationDuration duration: NSTimeInterval)
    optional func userProfileViewCellDidStopSummaryScroll(userProfileViewCell: UserProfileViewCell, withAnimationDuration duration: NSTimeInterval)
}

class UserProfileViewCell: UITableViewCell {

    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userSreenNameLabel: UILabel!
    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var userDescriptionLabel: UILabel!

    @IBOutlet weak var userProfileCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionCenterConstraint: NSLayoutConstraint!


    var originalUserProfileCenterConstraint: CGFloat!
    var originalDescriptionCenterConstraint: CGFloat!

    var user: TwitterUser! {
        didSet {
            updateCellView()
        }
    }

    let blurFilter = CIFilter(name: "CIDiscBlur")
    let ciContext = CIContext(options: nil)

    weak var delegate: UserProfileViewCellDelegate?
    // MARK: - Lifecyle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        userProfileImageView?.contentMode = .ScaleAspectFit
        userProfileImageView?.layer.cornerRadius = 5
        userProfileImageView?.clipsToBounds = true
        userProfileImageView?.layer.borderColor = UIColor.whiteColor().CGColor
        userProfileImageView?.layer.borderWidth = 2.0
        layoutMargins = UIEdgeInsetsZero

        // set initial offset
        descriptionCenterConstraint.constant = 0.5 * self.bounds.width

        // add ui gesture
        let profilePanGesture = UIPanGestureRecognizer(target: self, action: "snippentViewPanned:")
        userProfileView.addGestureRecognizer(profilePanGesture)

        let descriptionPanGesture = UIPanGestureRecognizer(target: self, action: "snippentViewPanned:")
        descriptionView.addGestureRecognizer(descriptionPanGesture)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    // MARK: - Actions methods
    func snippentViewPanned(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(contentView)
        let velocity = sender.velocityInView(contentView)

        if sender.state == UIGestureRecognizerState.Began {
            originalUserProfileCenterConstraint = userProfileCenterConstraint.constant
            originalDescriptionCenterConstraint = descriptionCenterConstraint.constant
            delegate?.userProfileViewCellDidStartSummaryScroll?(self, withAnimationDuration: 0.2)
        } else if sender.state == UIGestureRecognizerState.Changed {
            userProfileCenterConstraint.constant = originalUserProfileCenterConstraint + translation.x
            descriptionCenterConstraint.constant = originalDescriptionCenterConstraint + translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
            delegate?.userProfileViewCellDidStopSummaryScroll?(self, withAnimationDuration: 0.2)
            UIView.animateWithDuration(0.2) {
                self.userProfileCenterConstraint.constant = velocity.x > 0 ? 0 : -0.5 * self.bounds.width - 0.5 * self.userProfileView.bounds.width
                self.descriptionCenterConstraint.constant = velocity.x > 0 ? 0.5 * self.bounds.width + 0.5 * self.userProfileView.bounds.width : 0
                self.pageController.currentPage = velocity.x > 0 ? 0 : 1
                self.layoutIfNeeded()
            }
        }
    }


    // MARK: - Helper methods
    private func updateCellView() {
        userProfileImageView?.setImageWithURL(user.profileRegularImageUrl)
        userNameLabel?.text = user.name
        userSreenNameLabel.text = user.stylizedScreenName
        userDescriptionLabel.text = user.userDescription

        if let _ = user.profileBannerUrl {
            contentView.backgroundColor = UIColor.clearColor()
        }
    }

}
