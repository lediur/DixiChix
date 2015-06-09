//
//  DrivingViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 5/15/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import UIKit

class DrivingViewController: UIViewController, CLLocationManagerDelegate {
    var dataBundle : Dictionary<String, AnyObject>?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var allMarkers: [GMSMarker] = []
    var orderedPath = Array<CLLocation>()
    var distances = [CoordPair : Double]()
    var startLocation = CLLocation()
    
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
        
        allMarkers = dataBundle!["allMarkers"] as! [GMSMarker]
        distances = dataBundle!["distances"] as! [CoordPair : Double]
        startLocation = dataBundle!["startLocation"] as! CLLocation
        
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
            var drivingLocationQuery = PFQuery(className: "DrivingLocation")
            drivingLocationQuery.whereKey("username", equalTo: NSUserDefaults.standardUserDefaults().stringForKey(kLoggedInUsernameKey)!)
            drivingLocationQuery.addDescendingOrder("updatedAt")
            drivingLocationQuery.getFirstObjectInBackgroundWithBlock() {
                (object, error) in
                
                if (error != nil || object == nil) {
                    // The user doesn't already have a DrivingLocation PFObject up in the Parse cloud, so create one for him/
                    var drivingLocation = PFObject(className: "DrivingLocation")
                    drivingLocation["latitude"] = location.coordinate.latitude
                    drivingLocation["longitude"] = location.coordinate.longitude
                    drivingLocation["altitude"] = location.altitude
                    drivingLocation["username"] = NSUserDefaults.standardUserDefaults().stringForKey(kLoggedInUsernameKey)
                    drivingLocation.saveInBackgroundWithBlock() { (success, error) in }
                } else {
                	object?["latitude"] = location.coordinate.latitude
                    object?["longitude"] = location.coordinate.longitude
                    object?.saveInBackgroundWithBlock() { (success, error) in }
                }
            }
        }
    }
    
    //wrapper for TSP variant
    func findBestPath() {
        
        var markers = Array<CLLocation>()
        
        for marker in allMarkers {
            markers.append(CLLocation(latitude:marker.position.latitude, longitude:marker.position.longitude))
        }
        
        var tsp = findTSP(markers, root : startLocation)
        
        println(tsp.minDistance)
        orderedPath = tsp.minPath
        
        uploadFlightPath()
    }
    
    func findTSP(markers : Array<CLLocation>, root : CLLocation) -> (minDistance: Double, minPath : Array<CLLocation>) {
        if (markers.count == 1) {
            var coordP = CoordPair(coord1: root.coordinate, coord2: markers[0].coordinate)
            return (distances[coordP]!, [root, markers[0]])
        }
        
        var minDistance = DBL_MAX
        var minPath = Array<CLLocation>()
        
        for marker in markers {
            var markersSubset = Array<CLLocation>(markers)
            markersSubset.removeAtIndex(find(markersSubset, marker)!)
            
            var tsp = findTSP(markersSubset, root : marker)
            
            var distance = distances[CoordPair(coord1: root.coordinate, coord2: marker.coordinate)]! + tsp.minDistance
            
            if (distance < minDistance) {
                minDistance = distance
                minPath = tsp.minPath
            }
        }
        
        minPath.insert(root, atIndex: 0)
        return (minDistance, minPath)
    }

    
    func uploadFlightPath () {
        // Add a FlightPath PFObject to Parse that represents the waypoints this logged in user has drawn out.
        var flightPath = PFObject(className: "FlightPath")
        var waypointsAsFloatPairs: [String] = []
        
        for point in orderedPath {
            waypointsAsFloatPairs.append("\(point.coordinate.latitude) \(point.coordinate.longitude)")
        }
        
        flightPath.addObjectsFromArray(waypointsAsFloatPairs, forKey: "waypoints")
        flightPath["username"] = NSUserDefaults.standardUserDefaults().stringForKey(kLoggedInUsernameKey)
        
        flightPath.saveInBackgroundWithBlock() { (success, error) in
            
        }
    }
}

