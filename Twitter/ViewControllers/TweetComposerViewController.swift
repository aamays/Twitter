//
//  TweetComposerViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 10/3/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class TweetComposerViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var currentUserImageView: UIImageView!

    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var replyToLabel: UILabel!
    @IBOutlet weak var postBarBottomConstraint: NSLayoutConstraint!

    var tweet: Tweets?

    var postMessage: String? {
        didSet {
        }
    }

    struct ViewConstants {
        static let CharacterLimit = 140
    }

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareView()

    }

    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

    // MARK: - View Actions
    @IBAction func dismissButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func postTweetTapped(sender: UIButton) {
    }


    // MARK: - Keyboard show notification functions
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let rect = frame.CGRectValue()

            UIView.animateWithDuration(1.0) { () -> Void in
                self.postBarBottomConstraint.constant = self.view.bounds.height - rect.origin.y
            }
        }
    }

    // MARK: - Helper methods
    private func prepareView() {
        currentUserImageView.layer.cornerRadius = 2
        currentUserImageView.clipsToBounds = true
        currentUserImageView.contentMode = .ScaleAspectFit

        if let userImageUrl = UserManager.CurrentUser?.profileRegularImageUrl {
            currentUserImageView.setImageWithURL(userImageUrl)
        }
    }

    private func updateUIWithTweetInfo() {
        if let name = tweet?.user?.name {
            replyToLabel?.text = "In reply to \(name)"
        }

        if let screenName = tweet?.user?.screenName {
            postMessage = "@\(screenName) "
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
