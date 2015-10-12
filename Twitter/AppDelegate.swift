//
//  AppDelegate.swift
//  Twitter
//
//  Created by Amay Singhal on 9/29/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {

        if let query = url.query {
            TwitterClient.updateAccessTokenFromUrlQuery(query)
        }

        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        if let archivedUser = UserManager.getLastActiveUser() {
            UserManager.CurrentUser = archivedUser
            // load manager VC with menu controller
            let menuVC = MainStoryboard.Storyboard.instantiateViewControllerWithIdentifier(MainStoryboard.MenuVCIdentifier) as? MenuViewController
            if let managerVC = MainStoryboard.Storyboard.instantiateViewControllerWithIdentifier(MainStoryboard.ManagerVCIdentifier) as? VCMangerViewController {
                managerVC.menuViewController = menuVC
                managerVC.contentViewController = menuVC?.initialViewController
                menuVC?.delegate = managerVC
                window?.rootViewController = managerVC
            }
        }

        UIApplication.sharedApplication().statusBarStyle = .LightContent
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AppConstants.UserDidLogoutNotification, object: nil)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentUserDidLogout:", name: AppConstants.UserDidLogoutNotification, object: nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // MARK: - Selector methods
    func currentUserDidLogout(sender: AnyObject?) {
        let loginVC = MainStoryboard.Storyboard.instantiateInitialViewController()
        window?.rootViewController = loginVC
    }
}

