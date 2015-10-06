## Twitter [(raw)](https://gist.githubusercontent.com/timothy1ee/b9b1860c8ecb4b0b1c18/raw/2adc3f63677d81644e00245cee891eee88907767/gistfile1.md)

This is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: 25 hours

### Features

#### Required

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

#### Optional

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

#### Additional

- [x] User can delete their tweet from table view (delete not impletmented in detail view)
- [x] Display tweet media in detail view
- [x] User can tag tweet with their current location
- [x] Partially working media feature. Implemented UIImagePickerViewController to select images to upload with the tweet. For me the API is throwing "Request failed: forbidden (403)" which I have not root caused yet.

### Walkthrough

![Video Walkthrough](TwitterDemo2.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

#### Installation setup instructions

* For app to work properly, you need to provide a valid Twitter application <b>Consumer Key</b> and <b>Consmer Secret</b> to the app. They can be created by going to [Application Management Console](https://apps.twitter.com) and clicking <b>Create New App</b>
 * After the creadentails are generated, you can get the credentials from <b>Keys and Access Tokens</b> tab
  ![Keys and Access Tokens](Twitter/TwitterApplicationKeyAndSecret.png)
* To add <b>Consumer Key</b> and <b>Consmer Secret</b> to the app, do following:
 * Open [CredentialsInfo.plist](https://github.com/aamays/Twitter/blob/master/Twitter/CredentialsInfo.plist) in Twitter folder
 * Set <b>ConsumerKey</b> key's value to your app's Consumer Key
 * Set <b>ConsumerSecret</b> key's value to your app's Consmer Secret
 * Save the file




#### Development/Testing environment

* Operating System: Yosemite v10.10.4
* Xcode v7.0
* iOS v9.0
* Devices
 * iPhone 6 Simulator
