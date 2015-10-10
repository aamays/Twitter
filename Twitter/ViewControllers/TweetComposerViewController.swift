//
//  TweetComposerViewController.swift
//  Twitter
//
//  Created by Amay Singhal on 10/3/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import CoreLocation
import MobileCoreServices

@objc protocol TweetComposerViewControllerDelegate: class {
    optional func tweetComposerViewController(sender: UIViewController, didPostNewTweet: Tweets)
}


class TweetComposerViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    @IBOutlet weak var currentUserImageView: UIImageView!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var replyToLabel: UILabel!
    @IBOutlet weak var postBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topbarAndTextAreaVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var tweetComposerTextView: UITextView!
    @IBOutlet weak var toggleLocationButton: UIButton!
    @IBOutlet weak var addMediaButton: UIButton!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var placemarkLabel: UILabel!

    // Set up image view
    var mediaImageView = UIImageView()
    @IBOutlet weak var imageViewContainerView: UIView! {
        didSet {
            mediaImageView.contentMode = .ScaleAspectFit
            imageViewContainerView.addSubview(mediaImageView)
        }
    }

    var tweet: Tweets?

    var postMessage: String? {
        get {
            return tweetComposerTextView?.text
        }
        set(newValue) {
            if let _ = tweetComposerTextView {
                tweetComposerTextView.text = newValue
                remainingCharacterCount = remainingCharacterCount*1
            }
        }
    }

    var remainingCharacterCount: Int {
        get {
            return ViewConstants.CharacterLimit - (postMessage?.characters.count ?? 0)
        }
        set(newValue) {
            characterCountLabel?.text = "\(newValue)"
        }
    }

    weak var delegate: TweetComposerViewControllerDelegate?

    var composingNewTweet: Bool!

    var tagLocation = false {
        didSet {
            var titleColor = UIColor.lightGrayColor()
            if tagLocation {
                titleColor = AppConstants.Colors.LocationActivePinColor
                if let devicePlaceMark = devicePlaceMark {
                    placemarkLabel?.text = "\(devicePlaceMark.locality!), \(devicePlaceMark.administrativeArea!)"
                    placemarkLabel.alpha = 1
                }
            } else {
                deviceLocation = nil
                placemarkLabel.alpha = 0
            }
            toggleLocationButton?.setTitleColor(titleColor, forState: .Normal)
        }
    }

    var devicePlaceMark: CLPlacemark?
    var deviceLocation: CLLocation?
    let locationManager = CLLocationManager()

    var addMedia = false {
        didSet {
            var titleColor = UIColor.lightGrayColor()
            if addMedia {
                titleColor = AppConstants.Colors.MediaActiveIconColor
            }
            addMediaButton?.setTitleColor(titleColor, forState: .Normal)
        }
    }
    var tweetMediaIds: [String]?

    struct ViewConstants {
        static let CharacterLimit = 140
        static let BottomBarAnimationSlideUpDelayDuration = 0.5
        static let BottomBarAnimationSlideDownDelayDuration = 0.5
        static let CameraActionSheetText = "Camera"
        static let PhotoLibraryActionSheetText = "Photo Library"
        static let CameraRollActionSheetText = "Camera Roll"
        static let CancelActionSheetText = "Cancel"
    }

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareView()

        if let _ = tweet {
            updateUIWithTweetInfo()
        }

        tweetComposerTextView?.delegate = self
        tweetComposerTextView?.becomeFirstResponder()

        // initial set up for location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()

    }

    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self);
        locationManager.stopUpdatingLocation()
    }

    // MARK: - Location awreness
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            deviceLocation = location
        }

        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // update location code
            if let placemarks = placemarks {
                self.devicePlaceMark = placemarks[0]
            }
        })
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("\(error.localizedDescription)")
        deviceLocation = nil
    }

    // MARK: - View Actions
    @IBAction func dismissButtonTapped(sender: UIButton) {
        tweetComposerTextView?.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func postTweetTapped(sender: UIButton) {
        tweetComposerTextView?.resignFirstResponder()
        let location = tagLocation ? deviceLocation : nil
        let mediaIds = addMedia ? tweetMediaIds : nil
        UserManager.updateUserStatus(postMessage!, inResponseToStatusId: tweet?.id, andLocation: location, andMediaIds: mediaIds) { (tweet, error) -> () in
            if let userTweet = tweet {
                (self.composingNewTweet ?? true) ? self.delegate?.tweetComposerViewController?(self, didPostNewTweet: userTweet) : ()
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func captureMediaButton(sender: UIButton) {
        addMedia = !addMedia

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

        // Check if camera available
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            alert.addAction(UIAlertAction(title: ViewConstants.CameraActionSheetText, style: .Default) { (action: UIAlertAction) -> Void in
                self.presentPickerVCWithSourceType(.Camera)
            })
        }

        // Add Photo library
        alert.addAction(UIAlertAction(title: ViewConstants.PhotoLibraryActionSheetText, style: .Default) { (action: UIAlertAction) -> Void in
            self.presentPickerVCWithSourceType(.PhotoLibrary)
        })

        // Add Camera roll
        alert.addAction(UIAlertAction(title: ViewConstants.CameraRollActionSheetText, style: .Default) { (action: UIAlertAction) -> Void in
            self.presentPickerVCWithSourceType(.SavedPhotosAlbum)
        })
        alert.addAction(UIAlertAction(title: ViewConstants.CancelActionSheetText, style: UIAlertActionStyle.Cancel, handler: nil))

        self.presentViewController(alert, animated: true, completion: nil)

    }

    private func presentPickerVCWithSourceType(sourceType: UIImagePickerControllerSourceType) {
        let pickerVC = UIImagePickerController()
        pickerVC.mediaTypes = [kUTTypeImage as String]
        pickerVC.allowsEditing = true
        pickerVC.delegate = self
        pickerVC.sourceType = sourceType
        presentViewController(pickerVC, animated: true, completion: nil)
    }

    @IBAction func toggleLocationTagging(sender: UIButton) {
        tagLocation = !tagLocation
    }

    // MARK: - Keyboard show notification functions
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let rect = frame.CGRectValue()

            UIView.animateWithDuration(ViewConstants.BottomBarAnimationSlideUpDelayDuration) { () -> Void in
                self.postBarBottomConstraint.constant = self.view.bounds.height - rect.origin.y
                let newImageHeight = rect.origin.y - self.bottomBarView.frame.height - self.imageViewContainerView.frame.origin.y - self.topbarAndTextAreaVerticalSpaceConstraint.constant
                self.mediaImageView.frame = CGRect(x: 0, y: 0, width: self.mediaImageView.frame.width, height: newImageHeight)
            }
        }
    }

    func keyboardWillHide(sender: NSNotification) {
        UIView.animateWithDuration(ViewConstants.BottomBarAnimationSlideDownDelayDuration) { () -> Void in
            self.postBarBottomConstraint.constant = 0
        }
    }

    // MARK: - UI Text view delegate methods
    func textViewDidChange(textView: UITextView) {
        remainingCharacterCount = remainingCharacterCount*1
        if remainingCharacterCount == 0 {
            characterCountLabel?.textColor = UIColor.redColor()
        } else if remainingCharacterCount < 0 {
            postMessage = postMessage!.substringToIndex((postMessage?.endIndex.predecessor())!)
            AppUtils.shakeUIView(characterCountLabel)
        } else {
            characterCountLabel?.textColor = UIColor.blackColor()
        }
    }

    // MARK: - Image Picker delegate functions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }

        mediaImageView.image = image
        makeRoomForImage()
        dismissViewControllerAnimated(true, completion: nil)
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                UserManager.uploadMedia(imageData) { (uploadedMediaDetails: NSDictionary?, error: NSError?) -> () in
                    if let mediaIdString = uploadedMediaDetails?[TwitterClient.ResponseFields.Media.IdString] as? String {
                        if self.tweetMediaIds == nil { self.tweetMediaIds = [String]() }
                        self.tweetMediaIds?.append(mediaIdString)
                    }
                }
            }
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Helper methods
    private func prepareView() {
        currentUserImageView.layer.cornerRadius = 2
        currentUserImageView.clipsToBounds = true
        currentUserImageView.contentMode = .ScaleAspectFit

        if let userImageUrl = UserManager.CurrentUser?.profileRegularImageUrl {
            currentUserImageView.setImageWithURL(userImageUrl)
        }

        topBarView.addBorderToViewAtPosition(.Bottom)
        bottomBarView.addBorderToViewAtPosition(.Top)
    }

    private func updateUIWithTweetInfo() {
        if let name = tweet?.user?.name {
            replyToLabel?.attributedText = AppUtils.getAttributedStringForActionButtons("In reply to \(name)", icon: .ShortDownArrow, iconTextColor: UIColor.darkGrayColor(), withIconSize: 11, andBaseLine: -2)
            replyToLabel.alpha = 1
        }

        if let screenName = tweet?.user?.stylizedScreenName {
            postMessage = "\(screenName) "
        }
    }

    private func makeRoomForImage() {
        var extraHeight: CGFloat = 0
        if mediaImageView.image?.aspectRatio > 0 {
            if let width = mediaImageView.superview?.frame.size.width {
                let height = width / mediaImageView.image!.aspectRatio
                extraHeight = height - mediaImageView.frame.height
                mediaImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        } else {
            extraHeight = -mediaImageView.frame.height
            mediaImageView.frame = CGRectZero
        }

        preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
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

