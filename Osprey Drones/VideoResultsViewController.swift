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
    let cellImageHeight = 200.0
    
    
    // Note that this is a View Controller that contains a table view. The reason for this is that
    // if we use the default table view controller, there are conflicts with the status bar.
    // Putting the table view in another view controller allows us to use autolayout to avoid
    // this problem.
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoRemoveThisImages.count
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
        
        return cell
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