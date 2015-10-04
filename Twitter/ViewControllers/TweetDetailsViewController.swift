//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tweetDetailsTableView: UITableView!

    let displayCellRows = [UITableViewCell]()
    // MARK: - Lifecyle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayCellRows.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    // MARK: - Helper methods
    private func setupTableView() {
        tweetDetailsTableView.delegate = self
        tweetDetailsTableView.dataSource = self
        tweetDetailsTableView.rowHeight = UITableViewAutomaticDimension
        tweetDetailsTableView.estimatedRowHeight = TweetAndOwnerViewCell.EstimatedRowHeight
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
