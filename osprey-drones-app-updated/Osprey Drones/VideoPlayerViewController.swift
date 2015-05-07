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
        PFAnalytics.trackEventInBackground("ShareVideoToFacebook", dimensions: nil) { (success, error) in }
        
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
        PFAnalytics.trackEventInBackground("ShareVideoToTwitter", dimensions: nil) { (success, error) in }
        
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
        // For whatever reason we need to pass in dimensions so that this event is tracked. The other events are able to be tracked without dimensions, though...
        PFAnalytics.trackEventInBackground("ShareVideoToOther", dimensions: ["other":"other"]) { (success, error) in }
        
        let textToShare = "Check out my driving on YouTube!"
        
        if let videoLinkToShare = NSURL(string: "http://www.youtube.com/watch?v=\(videoIDToDisplay)")
        {
            let objectsToShare = [textToShare, videoLinkToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [
            	UIActivityTypeAddToReadingList
            ]
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    // Because the entire application is locked to portrait, besides this screen.
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
