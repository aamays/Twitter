//
//  MenuViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 10/8/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

@objc protocol MenuViewControllerDelegate: class {
    optional func menuViewController(menuViewController: MenuViewController, didSelectedViewController selectedViewController: UIViewController)
}


class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    // MARK: - Properties
    @IBOutlet weak var menuTableView: UITableView!

    struct ViewConstants {
        static let EstimatedRowHeight: CGFloat = 80
    }

    var menuViewCells: [MenuViewCellType] = [.MenuProfileViewCell]
    var currentSelectedCellIndex = 0
    lazy var menuOptions: [MenuOption] = {
        [unowned self] in
        var optionVCs = [MenuOption]()
        // Initialize all the required view controllers and set them in menuOptionsViewController
        // 1) Home Timeline VC
        if let homeTimelineNavVC = MainStoryboard.Storyboard.instantiateViewControllerWithIdentifier(AppConstants.MainStoryboard.TimelineNavVCIdentifier) as? UINavigationController {
            if let homeTimelineVC = homeTimelineNavVC.topViewController as? TimelineViewController {
                homeTimelineVC.currentUser = UserManager.CurrentUser
                homeTimelineVC.timelineType = .Home
                optionVCs.append(HomeMenuOption(selected: false, viewController: homeTimelineNavVC))
                self.menuViewCells.append(.MenuOptionViewCell)
            }
        }

        // 2) Mentions Timeline VC
        if let mentionsTimelineNavVC = MainStoryboard.Storyboard.instantiateViewControllerWithIdentifier(AppConstants.MainStoryboard.TimelineNavVCIdentifier) as? UINavigationController {
            if let mentionsTimelineVC = mentionsTimelineNavVC.topViewController as? TimelineViewController {
                mentionsTimelineVC.currentUser = UserManager.CurrentUser
                mentionsTimelineVC.timelineType = .Mentions
                optionVCs.append(MentionsMenuOption(selected: false, viewController: mentionsTimelineNavVC))
                self.menuViewCells.append(.MenuOptionViewCell)
            }
        }

        // 3) User Profile VC
        if let userProfileVC = MainStoryboard.Storyboard.instantiateViewControllerWithIdentifier(MainStoryboard.UserProfileVCIdentifier) as? UserProfileViewController {
            optionVCs.append(ProfileMenuOption(selected: false, viewController: userProfileVC))
            userProfileVC.user = UserManager.CurrentUser
            self.menuViewCells.append(.MenuOptionViewCell)
        }

        // make first VC selected
        optionVCs[0].isSelected = true

        return optionVCs
    }()

    var initialViewController: UIViewController? {
        return menuOptions.count > 0 ? menuOptions[0].viewController : nil
    }

    weak var delegate: MenuViewControllerDelegate?

    // MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }

    // MARK: Table View Delegate/Data Source methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuViewCells.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableRow = indexPath.row

        if tableRow == 0 {
            let profileCell = menuTableView.dequeueReusableCellWithIdentifier(menuViewCells[tableRow].rawValue, forIndexPath: indexPath) as! MenuProfileViewCell
            profileCell.user = UserManager.CurrentUser
            return profileCell
        } else {
            let optionCell = menuTableView.dequeueReusableCellWithIdentifier(menuViewCells[tableRow].rawValue, forIndexPath: indexPath) as! MenuOptionViewCell
            optionCell.menuOption = menuOptions[tableRow-1]
            return optionCell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        menuTableView.deselectRowAtIndexPath(indexPath, animated: true)

        if menuViewCells[indexPath.row] == MenuViewCellType.MenuOptionViewCell {
            var indexPathsToReload = [NSIndexPath]()
            // remove old index selected state
            menuOptions[currentSelectedCellIndex].isSelected = false
            indexPathsToReload.append(NSIndexPath(forItem: currentSelectedCellIndex+1, inSection: 0))

            // update current option selected status
            currentSelectedCellIndex = indexPath.row-1
            menuOptions[currentSelectedCellIndex].isSelected = true
            indexPathsToReload.append(indexPath)

            // reload options
            menuTableView.reloadRowsAtIndexPaths(indexPathsToReload, withRowAnimation: .Fade)

            // change the content
            delegate?.menuViewController?(self, didSelectedViewController: menuOptions[currentSelectedCellIndex].viewController)
        }
    }

    // MARK: - Helper methods
    private func setupTableView() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.estimatedRowHeight = ViewConstants.EstimatedRowHeight
        menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        menuTableView.tableFooterView = UIView(frame: CGRectZero)
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
