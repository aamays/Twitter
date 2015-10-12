//
//  VCMangerViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 10/8/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class VCMangerViewController: UIViewController, MenuViewControllerDelegate {

    // MARK: - Properties
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var contentViewLeftMarginConstraint: NSLayoutConstraint!

    var originalLeftMargin: CGFloat!

    // MARK: - Initialization
    var menuViewController: MenuViewController? {
        didSet(oldViewController) {
            updateMenuView(oldViewController)
        }
    }

    var contentViewController: UIViewController? {
        didSet(oldViewController) {
            updateContentView(oldViewController)
        }
    }

    struct ViewConstants {
        static let ContentViewSlideAnimationDuration = 0.2
    }

    enum MenuState: CGFloat {
        case Closed = 0, Open = 100 // these constants are used for position content view (by setting contentViewLeftMarginConstraint)
    }

    var isMenuOpen = false

    // MARK: - View lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateMenuView(nil)
        updateContentView(nil)
    }

    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu:", name: AppConstants.ToggleMenuNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AppConstants.ToggleMenuNotification, object: nil)
    }

    // MARK: - View Action methods
    @IBAction func menuPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)

        if sender.state == UIGestureRecognizerState.Began {
            originalLeftMargin = contentViewLeftMarginConstraint.constant
            self.menuView.alpha = 1
        } else if sender.state == UIGestureRecognizerState.Changed {
            contentViewLeftMarginConstraint.constant = max(min(originalLeftMargin + translation.x, self.view.bounds.width - MenuState.Open.rawValue), 0)
        } else if sender.state == UIGestureRecognizerState.Ended {
            (velocity.x < 0) ? closeMenu() : openMenu()
        }
    }

    // MARK: - Menu view controller delegate methods
    func menuViewController(menuViewController: MenuViewController, didSelectedViewController selectedViewController: UIViewController) {

        // close the menu
        closeMenu()

        // animate switch transition
        UIView.animateWithDuration(ViewConstants.ContentViewSlideAnimationDuration) { () -> Void in
            self.contentViewController = selectedViewController
            self.view.layoutIfNeeded()
        }

    }

    // MARK: - Internal methods
    private func updateMenuView(oldViewController: UIViewController?) {
        if let menuVC = menuViewController, let menuView = menuView {
            let frame = CGRect(x: 0, y: 0, width: menuView.frame.width - MenuState.Open.rawValue, height: menuView.frame.height)
            cycleContentViewController(menuVC, withFrame: frame, inView: menuView, withOldViewController: oldViewController)
        }
    }

    private func updateContentView(oldViewController: UIViewController?) {
        if let contentView = contentView, let contentViewController = contentViewController {
            let frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
            cycleContentViewController(contentViewController, withFrame: frame, inView: contentView, withOldViewController: oldViewController)
        }
    }

    private func cycleContentViewController(viewController: UIViewController, withFrame frame: CGRect, inView view: UIView, withOldViewController oldViewController: UIViewController?) {
        // remove previous view controller if any
        oldViewController?.willMoveToParentViewController(nil)
        oldViewController?.view.removeFromSuperview()
        oldViewController?.didMoveToParentViewController(nil)

        // Get the start frame of the new view controller and the end frame
        // for the old view controller. Both rectangles are offscreen.
        viewController.view.frame = frame

        // add new content view controller
        viewController.willMoveToParentViewController(self)
        view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }

    func toggleMenu(sender: AnyObject?) {
        isMenuOpen ? closeMenu() : openMenu()
    }

    private func openMenu(animateWithDuration: Double = ViewConstants.ContentViewSlideAnimationDuration) {
        isMenuOpen = true
        self.menuView.alpha = 1
        UIView.animateWithDuration(animateWithDuration) { () -> Void in
            self.contentViewLeftMarginConstraint.constant = self.view.bounds.width - MenuState.Open.rawValue
            self.view.layoutIfNeeded()
        }
    }

    private func closeMenu(animateWithDuration: Double = ViewConstants.ContentViewSlideAnimationDuration) {
        isMenuOpen = false
        UIView.animateWithDuration(animateWithDuration, animations: { () -> Void in
            self.contentViewLeftMarginConstraint.constant = MenuState.Closed.rawValue
            self.view.layoutIfNeeded()
            }) { (status: Bool) -> Void in
            self.menuView.alpha = 0
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
