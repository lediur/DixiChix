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
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
    	navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func shareOnFacebookButtonPressed(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Check out my driving at http://www.youtube.com/watch?v=\(videoIDToDisplay)")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = GeneralUtils.createAlertWithMessage("Please login to a Facebook account in your iPhone Settings to share.", title: "Accounts", buttonTitle: "OK")
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareOnTwitterButtonPressed(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Check out my driving at http://www.youtube.com/watch?v=\(videoIDToDisplay)")
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = GeneralUtils.createAlertWithMessage("Please login to a Twitter account in your iPhone Settings to share.", title: "Accounts", buttonTitle: "OK")
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareOnLinkButtonPressed(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = "http://www.youtube.com/watch?v=\(videoIDToDisplay)"
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
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
