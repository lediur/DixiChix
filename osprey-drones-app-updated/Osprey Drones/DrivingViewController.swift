//
//  DrivingViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 5/15/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import UIKit

class DrivingViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var doneDrivingButton: UIButton!
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // No more updates are needed after the user is done driving.
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        doneDrivingButton.layer.cornerRadius = doneDrivingButton.frame.size.height / 4
    }
    
    // MARK: CLLocationManagerDelegate methods
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            // Permissions should already have been granted in the Google Maps view. We can start asking the location manager for updates on the user's location.
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            var drivingLocation = PFObject(className: "DrivingLocation")
            drivingLocation["latitude"] = location.coordinate.latitude
            drivingLocation["longitude"] = location.coordinate.longitude
            drivingLocation["username"] = NSUserDefaults.standardUserDefaults().stringForKey(kLoggedInUsernameKey)
            drivingLocation.saveInBackgroundWithBlock() { (success, error) in }
        }
    }

}

