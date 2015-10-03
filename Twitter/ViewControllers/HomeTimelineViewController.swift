//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 9/30/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class HomeTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navController = navigationController {
            // set application default colors
            AppUtils.updateTextAndTintColorForNavBar(navController, tintColor: nil, textColor: nil)
        }

        setupTableView()

        updateUserTweets()
    }

    // MARK: - Table Delegate and Data Source methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUserTweets?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweetCell = homeTimelineTableView.dequeueReusableCellWithIdentifier(TweetsTableViewCell.Indentifier, forIndexPath: indexPath) as! TweetsTableViewCell
        tweetCell.tweet = currentUserTweets?[indexPath.row]
        return tweetCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        homeTimelineTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - View Actions
    @IBAction func logoutButtonItemTapped(sender: UIBarButtonItem) {
        UserManager.logoutCurrentUser()
    }

    func refresh(sender: AnyObject?) {
        updateUserTweets()
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

    private func updateUserTweets() {
        Tweets.getCurrentUserTweetsWithCompletion{ (userTweets:[Tweets]?, error: NSError?) -> () in
            self.currentUserTweets = userTweets
        }
    }

    private func updateTableView() {
        homeTimelineTableView.reloadData()
        if tweetsRefreshControl.refreshing {
            tweetsRefreshControl.endRefreshing()
        }
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
