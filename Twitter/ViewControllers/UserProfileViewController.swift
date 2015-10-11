//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 10/9/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userProfileTableView: UITableView!
    @IBOutlet weak var uiNavBackButton: UIButton!

    struct ViewConstants {
        static let EstimatedRowHeight: CGFloat = 100
        static let DefaultViewTitle = "Me"
    }

    var user: TwitterUser!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()

        title = ViewConstants.DefaultViewTitle
        uiNavBackButton.alpha = navigationController != nil ? 1 : 0
    }

    var origEdgesForExtendedLayoutValue: UIRectEdge!

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
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = userProfileTableView.dequeueReusableCellWithIdentifier("UserProfileViewCell", forIndexPath: indexPath) as! UserProfileViewCell
        cell.user = user
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        userProfileTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    // MARK: - Helper methods
    private func setupTableView() {
        userProfileTableView.delegate = self
        userProfileTableView.dataSource = self
        userProfileTableView.rowHeight = UITableViewAutomaticDimension
        userProfileTableView.estimatedRowHeight = ViewConstants.EstimatedRowHeight
        userProfileTableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
