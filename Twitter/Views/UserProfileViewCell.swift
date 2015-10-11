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
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userSreenNameLabel: UILabel!
    @IBOutlet weak var userProfileView: UIView!

    @IBOutlet weak var profileImageRightMarginConstraint: NSLayoutConstraint!

    var originalRightMarginConstraint: CGFloat!

    var user: TwitterUser! {
        didSet {
            updateCellView()
        }
    }

    let blurFilter = CIFilter(name: "CIDiscBlur")
    let ciContext = CIContext(options: nil)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        userProfileImageView?.contentMode = .ScaleAspectFit
        userProfileImageView?.layer.cornerRadius = 5
        userProfileImageView?.clipsToBounds = true
        userProfileImageView?.layer.borderColor = UIColor.whiteColor().CGColor
        userProfileImageView?.layer.borderWidth = 2.0
        layoutMargins = UIEdgeInsetsZero

//        // add ui gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: "profileViewPanned:")
        userProfileView.addGestureRecognizer(panGesture)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Actions methods
    func profileViewPanned(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(bannerImageView)
        //let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            originalRightMarginConstraint = profileImageRightMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.Changed {
            profileImageRightMarginConstraint.constant = originalRightMarginConstraint - translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
            
        }
    }

    private func updateCellView() {
        loadBannerImage()
        
        userProfileImageView?.setImageWithURL(user.profileRegularImageUrl)
        userNameLabel?.text = user.name
        userSreenNameLabel.text = user.stylizedScreenName
    }

    private func loadBannerImage() {
        if let blurFilter = blurFilter {
            blurFilter.setValue(12.0, forKey: "inputRadius")
            bannerImageView.setFilteredImageFromUrlRequest(NSURLRequest(URL: user.profileBannerUrl!), withFilter: blurFilter, andContext: ciContext, placeholderImage: nil, success: { (request: NSURLRequest, response: NSHTTPURLResponse, bannerImage: UIImage) -> Void in

                }) { (request: NSURLRequest, response: NSHTTPURLResponse, error: NSError) -> Void in

            }
        } else {
            print("No filter found")
            bannerImageView.setImageWithURL(user.profileBannerUrl!)
        }
    }
}
