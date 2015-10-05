//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 9/30/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class HomeTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetsTableViewCellDelegate, TweetComposerViewControllerDelegate, TweetDetailsViewControllerDelegate {

    // MARK: - Properties
    // MARK: Outlets
    @IBOutlet weak var homeTimelineTableView: UITableView!

    // MARK: Others
    var currentUser: TwitterUser!

    var currentUserTweets: [Tweets]? {
        didSet {
            updateTableView()
        }
    }

    var tweetsRefreshControl: UIRefreshControl!

    struct ViewConfigParameters {
        static let PopupAlertTitle = "We've hit a snag"
        static let PopupAlertOkButtonText = "Ok"
        static let PopupAlertDefaultMessage = "Could not fetch your Tweets!"
        static let CGRectTableTop = CGPoint(x: 0, y: -64)
        static let BarButtonItemTextSize = CGFloat(17)
        static let FetchMoreDataDiffThreshold = 5 // table will fetch more results from API if the difference between index of displaying cell and current count of tweets in timeline is less than this number
    }

    var canFetchMoreResults = true

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navController = navigationController {
            // set application default colors
            AppUtils.updateTextAndTintColorForNavBar(navController, tintColor: nil, textColor: nil)
        }

        setupTableView()

        updateUserTweets(nil, withOrder: nil)

        // customize nav bar // not working
        if let font = UIFont(name: "tfontastic", size: ViewConfigParameters.BarButtonItemTextSize) {
            navigationController?.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Selected)
        }

    }

    // MARK: - Table Delegate and Data Source methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUserTweets?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweetCell = homeTimelineTableView.dequeueReusableCellWithIdentifier(TweetsTableViewCell.Indentifier, forIndexPath: indexPath) as! TweetsTableViewCell
        tweetCell.tweet = currentUserTweets?[indexPath.row]
        tweetCell.cellIndex = indexPath.row
        tweetCell.delegate = self
        return tweetCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        homeTimelineTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (currentUserTweets!.count - indexPath.row) < ViewConfigParameters.FetchMoreDataDiffThreshold && canFetchMoreResults {
            updateUserTweets(currentUserTweets?.last?.id, withOrder: .Before)
        }
    }
    // MARK: - Tweet Cell view delegate methods
    func tweetCellFavoritedDidToggle(cell: TweetsTableViewCell, newValue: Bool) {
        let indexPath = homeTimelineTableView.indexPathForCell(cell)
        if let tweet = currentUserTweets?[indexPath!.row] {
            tweet.currentUserFavorited = newValue
            tweet.favoriteCount = newValue ? ++(tweet.favoriteCount!) : --(tweet.favoriteCount!)
            cell.tweet = tweet
            tweet.toggleFavoriteStatusWithCompletion { (success: Bool, error: NSError?) -> () in
                // @todo: Handle error
            }
        }
    }

    func tweetCellRetweetDidToggle(cell: TweetsTableViewCell, newValue: Bool) {
        let indexPath = homeTimelineTableView.indexPathForCell(cell)
        if let tweet = currentUserTweets?[indexPath!.row] {
            tweet.currentUserRetweeted = newValue
            tweet.retweetCount = newValue ? ++(tweet.retweetCount!) : --(tweet.retweetCount!)
            cell.tweet = tweet
            tweet.updateRetweetWithCompletion { (success: Bool, error: NSError?) -> () in
                // @todo: Handle error
            }
        }
    }

    func tweetCellDeleteStatus(cell: TweetsTableViewCell, withId id: Int) {
        let indexPath = homeTimelineTableView.indexPathForCell(cell)
        if let tweet = currentUserTweets?[indexPath!.row] {
            currentUserTweets?.removeAtIndex(indexPath!.row)
            homeTimelineTableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            UserManager.deleteStatusWithId(tweet.id!) { (success, error) -> () in
                // @todo: handle error cases here
            }
        }
    }

    // MARK: - TweetComposerVCDelegate methods
    func tweetComposerViewController(sender: UIViewController, didPostNewTweet tweet: Tweets) {
        currentUserTweets?.insert(tweet, atIndex: 0)
        homeTimelineTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
    }

    // MARK: - Tweet details view action delegate
    func tweetDetails(sender: UIViewController, userDidUpdateTweet tweet: Tweets) {
        // iterate through all the tweets and
        for (index, userTweet) in currentUserTweets!.enumerate() {
            if userTweet.id == tweet.id {
                currentUserTweets?.replaceRange(index...index, with: [tweet])
                homeTimelineTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None)
                break
            }
        }
    }

    // MARK: - View Actions
    @IBAction func logoutButtonTapped(sender: UIButton) {
        UserManager.logoutCurrentUser()
    }

    func refresh(sender: AnyObject?) {
        updateUserTweets(nil, withOrder: nil)
    }

    @IBAction func barHomeButtonTapped(sender: UIButton) {
        homeTimelineTableView.setContentOffset(ViewConfigParameters.CGRectTableTop, animated:true)
        updateUserTweets(nil, withOrder: nil)
    }

    // MARK: - View helper methods

    private func setupTableView() {
        homeTimelineTableView.delegate = self
        homeTimelineTableView.dataSource = self
        homeTimelineTableView.rowHeight = UITableViewAutomaticDimension
        homeTimelineTableView.estimatedRowHeight = TweetsTableViewCell.EstimatedRowHeight

        // Add refresh controller
        tweetsRefreshControl = UIRefreshControl()
        tweetsRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        homeTimelineTableView.addSubview(tweetsRefreshControl)
    }

    private func updateUserTweets(id: Int?, withOrder order: HomeTimeLineFetchOrder?) {
        Tweets.getCurrentUserTweetsWithCompletion(id, withOrder: order) { (userTweets:[Tweets]?, error: NSError?) -> () in
            if error == nil {
                if let order = order {
                    switch order {
                    case .Since:
                        print("Sie")
                    case .Before:
                        if let lastItemIndex = self.currentUserTweets?.count, let newTweets = userTweets {
                            let insertIndex = lastItemIndex - 1
                            self.currentUserTweets?.last!.id == userTweets?.first?.id ? self.currentUserTweets?.replaceRange(insertIndex...insertIndex, with: newTweets) : ()
                        }
                    }
                } else {
                    self.currentUserTweets = userTweets
                }

                // fetch retweet id if retweeted by user
                for tweet in self.currentUserTweets! {
                    if tweet.retweetId == nil && tweet.currentUserRetweeted! {
                        tweet.updateRetweetId()
                    }
                }
            } else {
                self.displayInformationalAlertView(ViewConfigParameters.PopupAlertDefaultMessage)
            }
        }
    }

    private func updateTableView() {
        homeTimelineTableView.reloadData()
        if tweetsRefreshControl.refreshing {
            tweetsRefreshControl.endRefreshing()
        }
    }

    private func displayInformationalAlertView(withMessage: String) {
        let alert = UIAlertController(title: ViewConfigParameters.PopupAlertTitle, message: withMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ViewConfigParameters.PopupAlertOkButtonText, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let navVC = segue.destinationViewController as? TweetComposerViewController {
            if segue.identifier == AppConstants.MainStoryboard.ComposeReplySegueIdentifier {
                if let tag = sender?.tag {
                    navVC.tweet = currentUserTweets?[tag]
                }
                navVC.composingNewTweet = false
            } else if segue.identifier == AppConstants.MainStoryboard.ComposeNewStatusSegueIndentifier {
                navVC.composingNewTweet = true
            }
            navVC.delegate = self
        } else if let navVC = segue.destinationViewController as? TweetDetailsViewController {
            if let cell = sender as? TweetsTableViewCell {
                let indexPath = homeTimelineTableView.indexPathForCell(cell)
                navVC.displayTweet = currentUserTweets?[(indexPath?.row)!]
                navVC.delegate = self
            }
        }
    }


}
