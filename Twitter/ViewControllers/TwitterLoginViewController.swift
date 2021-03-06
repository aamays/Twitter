//
//  TwitterLoginViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 9/29/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterLoginViewController: UIViewController {

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - View Actions
    @IBAction func loginButtonTapped(sender: UIButton) {
        UserManager.loginUserWithCompletion { (user: TwitterUser?, error: NSError?) -> Void in
            self.performSegueWithIdentifier(AppConstants.MainStoryboard.ShowHomeTimelineSegueIdentifier, sender: self)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let managerVC = segue.destinationViewController as? VCMangerViewController {
            let menuVC = MainStoryboard.Storyboard.instantiateViewControllerWithIdentifier(MainStoryboard.MenuVCIdentifier) as? MenuViewController
            menuVC?.delegate = managerVC

            managerVC.menuViewController = menuVC
            managerVC.contentViewController = menuVC?.initialViewController

        }
    }
}
