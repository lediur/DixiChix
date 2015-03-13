//
//  VideoResultsViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 3/12/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import Foundation

class VideoResultsViewController: UITableViewController, UITableViewDelegate {
    
    let cellReuseIdentifier = "VideoResultCell"
    let cellPictures = ["BMW_Car_1.jpg", "BMW_Car_2.jpg", "BMW_Car_3.jpg", "BMW_Car_4.jpg", "BMW_Car_5.jpg", "BMW_Car_6.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellPictures.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as VideoResultCell
        
		cell.title!.text = "MERP"
	
        if let thumbnailImage = UIImage(named: cellPictures[indexPath.row]) {
            let size = thumbnailImage.size
            let scaledHeight = 200.0
            let scaledWidth = scaledHeight * Double(size.height) / Double(size.width)
            let scaledSize = CGSizeMake(CGFloat(scaledHeight), CGFloat(scaledWidth))
            
            cell.thumbnail!.image = imageResize(thumbnailImage, sizeChange: scaledSize)
        }
        
        return cell
    }
    
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