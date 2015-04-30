//
//  CoordinatesViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 4/29/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import UIKit

class CoordinatesViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBAction func continueButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("showVideoResultsFromCoordinates", sender: self)
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        if let allViewControllers = navigationController?.viewControllers as? [UIViewController] {
            // Attempt to go back to the main menu, skipping the Google Maps VC
            for vc in allViewControllers {
                if vc.isKindOfClass(ViewController) {
                    navigationController?.popToViewController(vc, animated: true)
                }
            }
        } else {
            navigationController?.popToRootViewControllerAnimated(true)
        }
        
    }
    
    var allMarkers: [GMSMarker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Don't allow users to edit the textview.
        textView.editable = false
        
        var resultCoordinatesStr = ""
        
        for (index, marker) in enumerate(allMarkers) {
            resultCoordinatesStr += "Marker \(index+1)\n"
            resultCoordinatesStr += "Lat: \(marker.position.latitude)\n"
            resultCoordinatesStr += "Long: \(marker.position.longitude)\n\n"
        }
        
        textView.text = resultCoordinatesStr
    }

}

