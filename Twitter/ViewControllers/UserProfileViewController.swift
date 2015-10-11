//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 10/9/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import FXBlurView


class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UserProfileViewCellDelegate {

    @IBOutlet weak var userProfileTableView: UITableView!
    @IBOutlet weak var uiNavBackButton: UIButton!
    @IBOutlet weak var userProfileImageView: UIImageView!

    struct ViewConstants {
        static let EstimatedRowHeight: CGFloat = 100
        static let DefaultViewTitle = "Me"
        static let ScaleOffsetHeight: CGFloat = 35
    }

    var user: TwitterUser!

    var blurredImageView: UIImageView!

    // MARK: - Lifecyclem methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        setupImageView()
        title = ViewConstants.DefaultViewTitle
        uiNavBackButton.alpha = navigationController != nil ? 1 : 0

        // instantiate blurred image view
        blurredImageView = UIImageView(frame: userProfileImageView.bounds)
        blurredImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        blurredImageView?.alpha = 0.4
        userProfileImageView.addSubview(blurredImageView)
    }

    var origEdgesForExtendedLayoutValue: UIRectEdge!

    var profileDetailsViewRows: [UserProfileTableCell] = [.UserProfileViewCell, .ProfileSummaryViewCell]

    // MARK: View Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        origEdgesForExtendedLayoutValue = edgesForExtendedLayout
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
    }

    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        edgesForExtendedLayout = origEdgesForExtendedLayoutValue
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = true
    }

    // MARK: - Table View Delegate and Data Source Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDetailsViewRows.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndetifier = profileDetailsViewRows[indexPath.row]
        switch cellIndetifier {
        case .UserProfileViewCell:
            let cell = userProfileTableView.dequeueReusableCellWithIdentifier(cellIndetifier.rawValue, forIndexPath: indexPath) as! UserProfileViewCell
            cell.user = user
            cell.delegate = self
            return cell
        case .ProfileSummaryViewCell:
            let cell = userProfileTableView.dequeueReusableCellWithIdentifier(cellIndetifier.rawValue, forIndexPath: indexPath) as! ProfileSummaryViewCell
            cell.user = user
            return cell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        userProfileTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Scroll view delegate functions
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y

        var headerTransform = CATransform3DIdentity

        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / userProfileImageView.bounds.height
            let headerSizevariation = ((userProfileImageView.bounds.height * (1.0 + headerScaleFactor)) - userProfileImageView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-30, -offset), 0)
        }

        blurredImageView?.alpha = min (1.0, abs(offset)/ViewConstants.ScaleOffsetHeight)
        userProfileImageView.layer.transform = headerTransform
    }

    // MARK: - User profile view cell delegate
    func userProfileViewCellDidStartSummaryScroll(userProfileViewCell: UserProfileViewCell, withAnimationDuration duration: NSTimeInterval) {
        UIView.animateWithDuration(duration) { () -> Void in
            self.blurredImageView.alpha = 0.8
        }
    }

    func userProfileViewCellDidStopSummaryScroll(userProfileViewCell: UserProfileViewCell, withAnimationDuration duration: NSTimeInterval) {
        UIView.animateWithDuration(duration) { () -> Void in
            self.blurredImageView.alpha = 0
        }
    }

    // MARK: - Helper methods
    private func setupTableView() {
        userProfileTableView.delegate = self
        userProfileTableView.dataSource = self
        userProfileTableView.rowHeight = UITableViewAutomaticDimension
        userProfileTableView.estimatedRowHeight = ViewConstants.EstimatedRowHeight
        userProfileTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }

    private func setupImageView() {
        if let bannerUrl = user.profileBannerUrl {
            NSLog("made request")
            userProfileImageView.setImageWithURLRequest(NSURLRequest(URL: bannerUrl), placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, bannerImage: UIImage!) -> Void in
                    NSLog("got response")
                    self.userProfileImageView.image = bannerImage
                    NSLog("making blurry")
                    self.blurredImageView?.image = bannerImage.blurredImageWithRadius(10, iterations: 20, tintColor: UIColor.clearColor())
                }) { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
                    // @todo: Handle error case
            }
        }
    }

    @IBAction func backButtonTapped(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
