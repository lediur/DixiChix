//
//  VideoResultsViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 3/12/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import Foundation

class VideoResultsViewController: UIViewController, UITableViewDelegate {
    
    let cellReuseIdentifier = "VideoResultCell"
    
    // TODO: Remove these hardcoded cell images. Thumbnails for actual videos, maybe?
    // ================================================================================================================================================ TODO ========================================================================================================================
    let todoRemoveThisImages = ["BMW_Car_1.jpg", "BMW_Car_2.jpg", "BMW_Car_3.jpg", "BMW_Car_4.jpg", "BMW_Car_5.jpg", "BMW_Car_6.jpg"]
    let todoRemoveThisLabels = ["Indianapolis Motor Speedway", "Nürburgring", "Circuit De Monaco", "Daytona International Speedway", "Las Vegas Motor Speedway", "Drag Race"]
    let todoRemoveThisVideoIDsToDisplay = ["AFtUpMTs4vI", "7k7bg2RDATk", "Te0V71sGoxA", "VYpOFimB7ZA", "DvKSQXsDHcI", "iRsV6YpLsKA"]
    let cellImageHeight = 175.0
    
    
    // Note that this is a View Controller that contains a table view. The reason for this is that
    // if we use the default table view controller, there are conflicts with the status bar.
    // Putting the table view in another view controller allows us to use autolayout to avoid
    // this problem.
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    
    // MARK: UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoRemoveThisImages.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(cellImageHeight)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as VideoResultCell
        
		cell.title!.text = todoRemoveThisLabels[indexPath.row]
	
        if let thumbnailImage = UIImage(named: todoRemoveThisImages[indexPath.row]) {
			// Preserve the width/height ratio when scaling, so calculate the appropriate scaled CGSize
            let size = thumbnailImage.size
            let scaledHeight = cellImageHeight
            let scaledWidth = scaledHeight * Double(size.height) / Double(size.width)
            let scaledSize = CGSizeMake(CGFloat(scaledHeight), CGFloat(scaledWidth))
            
            cell.thumbnail!.image = imageResize(thumbnailImage, sizeChange: scaledSize)
        }
        
        // Add a disclosure indicator to the table view cells to show that they can be selected!
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // TODO: Actually not sure if this is acceptable style or not... it makes it easier to identify what videoID/title to pass, though.
        self.performSegueWithIdentifier("toVideoPlayerViewController", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // This segue is called when the user clicks on a table row. The sender is the index path of the selected row.
        if segue.identifier == "toVideoPlayerViewController" {
            if let indexPathOfSender = sender as? NSIndexPath {
                var destinationVC = segue.destinationViewController as VideoPlayerViewController
                destinationVC.titleToDisplay = todoRemoveThisLabels[indexPathOfSender.row]
                destinationVC.videoIDToDisplay = todoRemoveThisVideoIDsToDisplay[indexPathOfSender.row]
            }
        }
    }
    
    // MARK: Generic Helpers
    
    /* Helper function to resize an image to fit the passed in 'sizeChange' CGSize */
    func imageResize(image: UIImage, sizeChange: CGSize) -> UIImage {
        let hasAlpha = true
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.drawInRect(CGRect(origin:CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return scaledImage
    }
}