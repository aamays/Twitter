//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//
// NOTE: I realized after adding code for partial code to display of tweet replies that twitter does not have
//       endpoint for tweets conversation tree (or rather that they deprecated in v1.1). I left the code here in
//       the view controller for now and I will clean up later
import UIKit

@objc protocol TweetDetailsViewControllerDelegate: class {
    optional func tweetDetails(sender: UIViewController, userDidUpdateTweet tweet: Tweets)
}

class TweetDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserActionViewCellDelegate {

    @IBOutlet weak var tweetDetailsTableView: UITableView!

    var displayCellTypes: [TweetDetailsViewCell] = [.TweetAndOwnerViewCell, .TweetMediaViewCell, .TweetTimeStampViewCell, .TweetMeasuresViewCell, .UserActionViewCell]
    var counterCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
    var actionCellIndexPath = NSIndexPath(forRow: 4, inSection: 0)

    var displayTweet: Tweets! {
        didSet {
            if !displayTweet.hasMedia {
                displayCellTypes.removeAtIndex(1)
                counterCellIndexPath = NSIndexPath(forRow: 2, inSection: 0)
                actionCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)

            }
        }
    }

    weak var delegate: TweetDetailsViewControllerDelegate?

    var tweetReplies: [Tweets]? {
        didSet {
            tweetDetailsTableView.reloadSections(NSIndexSet(index: TableSections.TweetReplies.rawValue), withRowAnimation: UITableViewRowAnimation.Bottom)
        }
    }

    struct ViewConstants {
        static let NumberOfSectionsInTable = 2 // section 0 = Tweet details; section 1= Tweet replies
    }

    enum TableSections: Int {
        case TweetDetails = 0, TweetReplies
    }

    // MARK: - Lifecyle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }


    // MARK: Table delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ViewConstants.NumberOfSectionsInTable
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TableSections.TweetDetails.rawValue:
            return displayCellTypes.count
        case TableSections.TweetReplies.rawValue:
            return tweetReplies?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        // select cell type based on section
        var displayCellType = TweetDetailsViewCell.TweetRepliesViewCell
        if indexPath.section == TableSections.TweetDetails.rawValue {
            displayCellType = displayCellTypes[indexPath.row]
        }

        switch displayCellType {
        case .TweetAndOwnerViewCell:
            let tCell = tweetDetailsTableView.dequeueReusableCellWithIdentifier(displayCellType.rawValue, forIndexPath: indexPath) as! TweetAndOwnerViewCell
            tCell.tweet = displayTweet
            return tCell
        case .TweetMediaViewCell:
            let tCell = tweetDetailsTableView.dequeueReusableCellWithIdentifier(displayCellType.rawValue, forIndexPath: indexPath) as! TweetMediaViewCell
            tCell.mediaUrl = displayTweet.mediaUrl!
            return tCell
        case .TweetTimeStampViewCell:
            let tCell = tweetDetailsTableView.dequeueReusableCellWithIdentifier(displayCellType.rawValue, forIndexPath: indexPath) as! TweetTimeStampViewCell
            tCell.tweetDate = displayTweet.createdAt!
            return tCell
        case .TweetMeasuresViewCell:
            let tCell = tweetDetailsTableView.dequeueReusableCellWithIdentifier(displayCellType.rawValue, forIndexPath: indexPath) as! TweetMeasuresViewCell
            tCell.tweet = displayTweet
            return tCell
        case .UserActionViewCell:
            let tCell = tweetDetailsTableView.dequeueReusableCellWithIdentifier(displayCellType.rawValue, forIndexPath: indexPath) as! UserActionViewCell
            tCell.tweet = displayTweet
            tCell.delegate = self
            return tCell
        case .TweetRepliesViewCell:
            let tCell = tweetDetailsTableView.dequeueReusableCellWithIdentifier(displayCellType.rawValue, forIndexPath: indexPath) as! TweetRepliesViewCell
            return tCell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tweetDetailsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - User Action Delegate methods
    func userActionCellTappedReply() {
        performSegueWithIdentifier(AppConstants.MainStoryboard.ComposeReplySegueIdentifier, sender: self)
    }

    func userActionCellTappedFavorite(newValue: Bool) {
        displayTweet.currentUserFavorited = newValue
        displayTweet.favoriteCount = newValue ? ++(displayTweet.favoriteCount!) : --(displayTweet.favoriteCount!)
        displayTweet.toggleFavoriteStatusWithCompletion { (success: Bool, error: NSError?) -> () in
            // @todo: Handle error
        }

        // send delegate request to table view controller to reload cell
        delegate?.tweetDetails?(self, userDidUpdateTweet: displayTweet)

        // reload relevant cells in details view
        tweetDetailsTableView.reloadRowsAtIndexPaths([counterCellIndexPath, actionCellIndexPath], withRowAnimation: UITableViewRowAnimation.None)
    }

    func userActionCellTappedRetweet(newValue: Bool) {
        displayTweet.currentUserRetweeted = newValue
        displayTweet.retweetCount = newValue ? ++(displayTweet.retweetCount!) : --(displayTweet.retweetCount!)
        displayTweet.updateRetweetWithCompletion { (success: Bool, error: NSError?) -> () in
            // @todo: Handle error
        }

        // send delegate request to table view controller to reload cell
        delegate?.tweetDetails?(self, userDidUpdateTweet: displayTweet)

        // reload relevant cells in details view
        tweetDetailsTableView.reloadRowsAtIndexPaths([counterCellIndexPath, actionCellIndexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    // MARK: - Helper methods
    private func setupTableView() {
        tweetDetailsTableView.delegate = self
        tweetDetailsTableView.dataSource = self
        tweetDetailsTableView.rowHeight = UITableViewAutomaticDimension
        tweetDetailsTableView.estimatedRowHeight = TweetAndOwnerViewCell.EstimatedRowHeight
        tweetDetailsTableView.tableFooterView = UIView(frame: CGRectZero)
        tweetDetailsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == AppConstants.MainStoryboard.ComposeReplySegueIdentifier {
            if let composeReplyVC = segue.destinationViewController as? TweetComposerViewController {
                composeReplyVC.tweet = displayTweet
            }
        } else if segue.identifier == AppConstants.MainStoryboard.ShowFullImageSegueIdentifier {
            if let fullImageVC = segue.destinationViewController as? FullImageViewController {
                fullImageVC.imageUrl = displayTweet.mediaUrl
            }
        }
    }


}
