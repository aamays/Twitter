//
//  AccountsManagerViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 10/11/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class AccountsManagerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var userAccountsCollectionView: UICollectionView!

    var cellOriginalCenter: CGPoint!

    var userAccounts: [TwitterUser]!

    struct ViewConstants {
        static let MininumRemoveUserVelocity: CGFloat = 300
        static let RemoveUserAnimationDuration = 0.5
        static let RemoveUserScaleDownRatio: CGFloat = 0.01
        static let RemoveUserScaleDownTransform = CGAffineTransformMakeScale(CGFloat(0.1), CGFloat(0.1))
    }
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
    }

    override func viewWillAppear(animated: Bool) {
        userAccounts = UserManager.getArchivedUsers()
    }

    // MARK: - Collection View delegate and datasource methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userAccounts.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = userAccountsCollectionView.dequeueReusableCellWithReuseIdentifier(AccountManagerCell.UserAccountViewCell.rawValue, forIndexPath: indexPath) as! UserAccountViewCell
        cell.user = userAccounts[indexPath.row]
        let panGesture = UIPanGestureRecognizer(target: self, action: "accountCellPanned:")
        cell.addGestureRecognizer(panGesture)
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        UserManager.CurrentUser = userAccounts[indexPath.row]
        userAccounts = UserManager.getArchivedUsers()
        userAccountsCollectionView.reloadData()
        self.performSegueWithIdentifier(AppConstants.MainStoryboard.ShowHomeTimelineSegueIdentifier, sender: self)
    }

    // MARK: - Action methods
    @IBAction func dismissViewController(sender: UIButton?) {
        self.performSegueWithIdentifier(AppConstants.MainStoryboard.ShowHomeTimelineSegueIdentifier, sender: self)
    }

    @IBAction func addNewAccountButtonTapped(sender: UIButton) {
        UserManager.loginUserWithCompletion { (user: TwitterUser?, error: NSError?) -> Void in
            if error == nil {
                self.userAccounts = UserManager.getArchivedUsers()
                self.userAccountsCollectionView.reloadData()
                self.performSegueWithIdentifier(AppConstants.MainStoryboard.ShowHomeTimelineSegueIdentifier, sender: self)
            }

        }
    }

    // MARK: - Helper methods
    func accountCellPanned(sender: UIPanGestureRecognizer) {
        // velocity and trasnform to track user activity
        let translation = sender.translationInView(userAccountsCollectionView)
        let velocity = sender.velocityInView(userAccountsCollectionView)

        if sender.state == UIGestureRecognizerState.Began {
            cellOriginalCenter = sender.view!.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            sender.view!.center = CGPoint(x: cellOriginalCenter.x + translation.x, y: cellOriginalCenter.y + translation.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            if velocity.x > ViewConstants.MininumRemoveUserVelocity || velocity.y > ViewConstants.MininumRemoveUserVelocity {
                removeUserAccount(sender.view!) // remove the account of dragged cell
            } else {
                sender.view!.center = cellOriginalCenter
            }
        }
    }

    // MARK: - Internal methods
    private func setupCollectionView() {
        userAccountsCollectionView.delegate = self
        userAccountsCollectionView.dataSource = self
    }

    private func removeUserAccount(senderView: UIView) {
        if let senderView = senderView as? UICollectionViewCell {
            let indexPath = userAccountsCollectionView.indexPathForCell(senderView)
            UIView.animateWithDuration(ViewConstants.RemoveUserAnimationDuration, animations: { () -> Void in
                senderView.transform = ViewConstants.RemoveUserScaleDownTransform
                }, completion: { (status: Bool) -> Void in

                    let userToRemove = self.userAccounts[indexPath!.row]
                    TwitterUser.removetUserFromArchiveWithId(userToRemove.id)
                    if userToRemove.hasActiveSession {
                        UserManager.CurrentUser = nil
                    }
                    self.userAccounts.removeAtIndex(indexPath!.row)

                    if self.userAccounts.count == 0 {
                        self.performSegueWithIdentifier(MainStoryboard.ShowLoginSegueIdentifier, sender: self)
                    } else {
                        UserManager.CurrentUser = self.userAccounts[0]
                        self.userAccounts[0].hasActiveSession = true
                    }

                    self.userAccountsCollectionView.reloadData()
            })
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
