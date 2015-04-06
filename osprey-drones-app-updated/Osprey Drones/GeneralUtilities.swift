//
//  GeneralUtilities.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 4/5/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import Foundation

class GeneralUtils {
    
    // General purpose function to surface an alert with the specified error message and title.
    // Only one button is displayed, for the purposes of getting rid of the alert, which will be
    // the passed in buttonTitle.
    class func createAlertWithMessage(message: String, title: String, buttonTitle: String) -> UIAlertController {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default, handler: nil))
		return alert
    }
    
    // Returns whether or not the passed in string contains any whitespace.
    class func stringContainsWhitespace(str: String) -> Bool {
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        
        if let range = str.rangeOfCharacterFromSet(whitespace) {
            return true
        } else {
            return false
        }
    }
    
}