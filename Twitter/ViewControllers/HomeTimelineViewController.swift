//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 9/30/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class HomeTimelineViewController: UIViewController {

    var currentUser: TwitterUser!

    override func viewDidLoad() {
        super.viewDidLoad()


        print("Home Timeline is being loaded with new user: \(currentUser.name!)")
    }

    @IBAction func logoutButtonTapped(sender: UIButton) {
        UserManager.CurrentUser = nil
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
