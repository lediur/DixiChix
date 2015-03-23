//
//  VideoPlayerViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 3/12/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import Foundation
import UIKit
import Social

class VideoPlayerViewController: UIViewController {
    @IBOutlet weak var videoPlayerView: YTPlayerView!
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBAction func shareOnFacebookButtonPressed(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Check out my driving at http://www.youtube.com/watch?v=\(videoIDToDisplay)")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareOnTwitterButtonPressed(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Check out my driving at http://www.youtube.com/watch?v=\(videoIDToDisplay)")
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    var titleToDisplay = ""
    var videoIDToDisplay = "uDP7Pty8Qnw"

    override func viewDidLoad() {
        super.viewDidLoad()
	
        titleLabel.text = titleToDisplay
        videoPlayerView.loadWithVideoId(videoIDToDisplay)
    }
    
    // Only allow portrait mode for this view.
    override func shouldAutorotate() -> Bool {
        return false
    }
}
