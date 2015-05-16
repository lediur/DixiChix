//
//  GoogleMapsViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 3/12/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import Foundation

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
    	navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBAction func doneButtonPressed(sender: AnyObject) {
        PFAnalytics.trackEventInBackground("FlightPathDrawn", dimensions: ["numPoints":"\(self.allMarkers.count)"]) { (success, error) in }
        var flightPath = PFObject(className: "FlightPath")
        
        var waypointsAsFloatPairs: [String] = []
        for point in orderedPath {
            waypointsAsFloatPairs.append("\(point.coordinate.latitude) \(point.coordinate.longitude)")
        }
        flightPath.addObjectsFromArray(waypointsAsFloatPairs, forKey: "waypoints")
        flightPath["username"] = NSUserDefaults.standardUserDefaults().stringForKey(kLoggedInUsernameKey)
        self.view.userInteractionEnabled = false
        flightPath.saveInBackgroundWithBlock() { (success, error) in
            if self.allMarkers.count == 0 {
                self.performSegueWithIdentifier("showVideoResultsFromGoogleMaps", sender: self)
            }
            
            if let droneMarker = self.animateDroneMarker {
                println("We are already animating the drone...")
            } else {
                self.animateDroneAlongDrawnPath()
            }

            self.view.userInteractionEnabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showCoordinatesFromGoogleMaps") {
            if var coordinatesVC = segue.destinationViewController as? CoordinatesViewController {
                coordinatesVC.allMarkers = self.allMarkers
            }
        }
    }
    
    let locationManager = CLLocationManager()
    var allMarkers: [GMSMarker] = []
    var orderedPath = Array<CLLocation>()
    var distances = [CoordPair : Double]()
    var currentLocation = CLLocation(latitude: 37.427644499009219, longitude:-122.16890349984169)
    let markerInnerCircleRadius = 12.0
    let markerInnerCircleColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let markerOuterCircleRadius = 14.0
	let markerOuterCircleColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let markerTitleText = "Tap To Delete!"
    
    var drawnPath: GMSPolyline = GMSPolyline()
    
    // The marker we will use for animating our drone along the path. TODO: Could get rid of this and pass a GMSMarker by reference (inout param)
    var animateDroneMarker: GMSMarker?
    
    // Speed of the animateDroneMarker
    // TODO: Define constant somewhere that specifies this 125 value. Otherwise, when we change the default value in the storyboard, this value also needs to be changed.
    let animateDroneDistancePerSecond = CLLocationDistance(125.0)
    
    func timeToAnimateToNextMarkerStartingFromIndex(i: Int, withSpeed speed: CLLocationDistance) -> Double {
        var end = CLLocation(latitude: allMarkers[i+1].position.latitude, longitude: allMarkers[i+1].position.longitude)
        var start = CLLocation(latitude: allMarkers[i].position.latitude, longitude: allMarkers[i].position.longitude)
        var distance = end.distanceFromLocation(start)
        
        var animationTimeForThisLeg = distance / speed
        
        return animationTimeForThisLeg
    }
    
    func animateDroneStartingAtMarkerIndex(index: Int, withSpeed speed: CLLocationDistance) {
        // Stop animating when we are out of legs.
        if (index >= allMarkers.count - 1) {
            var alert = UIAlertController(title: "Drone Finished Recording", message: "What would you like to do from here?", preferredStyle: UIAlertControllerStyle.Alert)

            // Functionality to go to the page with recorded videos displayed in a table view.
            //TODO: Uncomment once we no longer need the Coordinates View Controller
//            alert.addAction(UIAlertAction(title: "See Recorded Video", style: UIAlertActionStyle.Default) {
//                action in
//                self.performSegueWithIdentifier("showVideoResultsFromGoogleMaps", sender: self)
//            })
            alert.addAction(UIAlertAction(title: "See Coordinates", style: UIAlertActionStyle.Default) {
                action in
                self.performSegueWithIdentifier("showCoordinatesFromGoogleMaps", sender: self)
            })
            
            // Functionality to go back to the home page if the user chooses to not view the recorded videos.
            alert.addAction(UIAlertAction(title: "Go Home", style: UIAlertActionStyle.Cancel) {
                action in
                self.navigationController?.popViewControllerAnimated(true)
            })
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        CATransaction.begin()
        
        // When this Core Animation Transaction is done, animate the next leg.
        CATransaction.setCompletionBlock({
            self.animateDroneStartingAtMarkerIndex(index + 1, withSpeed: speed)
        })
        
        // Set the time for this leg of the journey so that each leg of the journey
        // is traveled at the same speed, giving the illusion of a drone with constant speed.
        var animationTimeForThisLeg = timeToAnimateToNextMarkerStartingFromIndex(index, withSpeed: speed)
        CATransaction.setAnimationDuration(animationTimeForThisLeg)
        
        // Code to be animated.
        animateDroneMarker!.position = CLLocationCoordinate2D(latitude: allMarkers[index+1].position.latitude, longitude: allMarkers[index+1].position.longitude)
        
        CATransaction.commit()
    }
    
    
    func animateDroneAlongDrawnPath() {
        if allMarkers.count == 0 {
            return
        }
        
        animateDroneMarker = GMSMarker(position: allMarkers[0].position)
        animateDroneMarker!.icon = UIImage(named: "drone_icon-30.png")
        animateDroneMarker!.map = mapView
        
        // Get the speed of the drone from what the user has set in settings, or just
        // use the default value. TODO: Set constant for default speed rather than hardcoding value
        // up top in this file (otherwise a change in the storyboard would require a change here too.
        let defaults = NSUserDefaults.standardUserDefaults()
        if let droneSpeed = defaults.objectForKey("droneSpeedKey") as? Float {
            animateDroneStartingAtMarkerIndex(0, withSpeed: CLLocationDistance(droneSpeed))
        } else {
            animateDroneStartingAtMarkerIndex(0, withSpeed: animateDroneDistancePerSecond)
        }
        
    }
    
    // UIPopoverPresentationControllerDelegate method to specify popover view presentation style
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        numTimesPopoversDismissed++
        
        if (numTimesPopoversDismissed < instructionsTexts.count) {
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "showInstructionUsingTimer:", userInfo: numTimesPopoversDismissed, repeats: false)
        } else {
            var alert = UIAlertController(title: "Finished Showing Instructions", message: "What would you like to do from here?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Don't Show This Again!", style: UIAlertActionStyle.Default) {
                action in
                
                // Note down in User Defaults that this user does not want to be shown the instructions again
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(false, forKey: kShowMapPlottingInstructionsKey)
            })
            
            alert.addAction(UIAlertAction(title: "Instructions Again Please!", style: UIAlertActionStyle.Default) {
                action in
				
                // Give them another run-through of the instructions
                self.numTimesPopoversDismissed = 0
                self.showInstructionAtIndex(0)
            })
            
            alert.addAction(UIAlertAction(title: "I'm Good, For Now!", style: UIAlertActionStyle.Cancel) {
                action in
                // Dismiss the alert, but show them instructions next time.
            })
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // Not a safe function - before using must make sure that you pass in a valid integer index into the timer's userInfo variable.
    // Need to make sure that this index is valid.
    func showInstructionUsingTimer(timer: NSTimer) {
        let index = timer.userInfo as! Int
        showInstructionAtIndex(index)
    }
    
    func showInstructionAtIndex(index: Int) {
        let instructionText = instructionsTexts[index]
        let popoverHeight = instructionsHeights[index]
        
        if let instructionVC = storyboard?.instantiateViewControllerWithIdentifier("instructionViewController") as? InstructionViewController {
            instructionVC.textToBeSet = instructionText
            instructionVC.modalPresentationStyle = .Popover
            instructionVC.preferredContentSize = CGSizeMake(view.frame.width, popoverHeight)
            
            let popoverVC = instructionVC.popoverPresentationController
            popoverVC?.permittedArrowDirections = UIPopoverArrowDirection.allZeros
            popoverVC?.delegate = self
            popoverVC?.sourceView = view
            popoverVC?.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 250)
            self.presentViewController(instructionVC, animated: true, completion: nil)
        }
    }
    
    var numTimesPopoversDismissed = 0
    let instructionsTexts = [
		"This screen is for you to plot points where you want the drone to visit and record your driving.",
        "In order to plot a point for the drone to visit, simply hold a long press anywhere on the map.",
        "To remove a point, simply tap on it, and a button will appear asking you to \"Tap to Delete\"",
        "When you are satisfied with your placements, hit \"Done\" in the top right corner!"
        
    ]
    let instructionsHeights: [CGFloat] = [
        100,
        100,
        100,
        100
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // Set the initial location to be looking at Stanford University
        mapView.camera = GMSCameraPosition.cameraWithLatitude(37.427474, longitude: -122.169719, zoom: 15)
        mapView.delegate = self
        
        numTimesPopoversDismissed = 0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey(kShowMapPlottingInstructionsKey) == nil || defaults.boolForKey(kShowMapPlottingInstructionsKey) == true) {
            showInstructionAtIndex(0)
        }
    }
    
    // MARK: CLLocationManagerDelegate methods
    
    /* Invoke CCLocationManagerDelegate when the user grants or revokes location permissions. */
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            // Once permissions have been established, ask the location manager for updates on the user's location.
        	locationManager.startUpdatingLocation()
            
            // There are two features concerning the user's location:
            // 1) myLocatioNEnabled draws a light blue dot where the user is located.
            // 2) myLocationButton adds a button to the map that centers the user's location when tapped.
            mapView.myLocationEnabled = true
//            mapView.settings.myLocationButton = true
        }
    }
    
    /* Executes when the location manager receives new location data. */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            // This updates the map's camera to center around the user's current location. The GMSCameraPosition class
            // aggregates all camera position parameters and passes them to the map for display.
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            currentLocation = location
            
            // Tell locationManager we are no longer interested in updates. Initial location is enough to work with for now.
            locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: GMSMapViewDelegate methods
    
    /* When the user holds a long press on the map, draw a numbered marker there.
     * This numbered marker can be deleted by tapping the marker and then tapping
     * the info window that clearly states "Tap to Delete!" */
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        
        //Calculate distances
        calculateDistances(coordinate)
        
        // Draw the marker at the position
        var marker = GMSMarker(position: coordinate)
        marker.title = markerTitleText
        
        // The label of this marker should be one greater than the current size,
        // as it will soon be appended into the array that keeps track of all
        // the markers. Create a custom image for this number label that we will
        // use as the marker's icon.
        var label = "\(allMarkers.count + 1)"
        marker.icon = createCircleImageWithLabel(label)
        
        // Add the marker to the map.
        marker.map = mapView
        
        allMarkers.append(marker)
        
        //Calculate best path
        findBestPath()
        
        drawPathBetweenMarkers()
    }

    /* When the user taps on the info window, remove the marker that was tapped, and refresh
     * all the markers so that they are appropriately numbered. */
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
    	marker.map = nil
        removeObject(marker, fromArray: &allMarkers)
        refreshMapMarkers()
    }
    
    // MARK: Maps Helper functions
    
    /* Function to draw a path that goes step-by-step across the markers on screen. */
    func drawPathBetweenMarkers() {
        // Refresh the GMS Path
        var path = GMSMutablePath()
        for marker in allMarkers {
            path.addCoordinate(marker.position)
        }
        
        // Destroy the previously drawn path
        drawnPath.map = nil
        
        // Create a new one
        drawnPath = GMSPolyline(path: path)
        drawnPath.strokeWidth = 2.0
        drawnPath.map = mapView
    }

    /* Refreshes the markers so that they are appropriately numbered. Called after
     * markers are removed from the array. */
    func refreshMapMarkers() {
        for (index, marker) in enumerate(allMarkers) {
            var label = "\(index + 1)"
            marker.icon = createCircleImageWithLabel(label)
        }
        
        // We will need to re drawn the path to account for the removed markers.
        drawPathBetweenMarkers()
    }
    
    // MARK: Custom Maps Marker Drawing functions
    
    /* Function to convert a UIView into a UIImage */
    func createImageFromView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /* Function to draw text on top of a UIImage */
    func drawText(text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRectMake(0.0, 0.0, image.size.width, image.size.height))
        var rect = CGRectMake(point.x, point.y, image.size.width, image.size.height)
        text.drawInRect(rect, withAttributes: nil)
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /* Function to create a circular UIImage that contains some string label. */
    func createCircleImageWithLabel(label: String) -> UIImage {
        let view = createCircleViewWithLabel(label, innerCircleRadius: markerInnerCircleRadius, innerCircleColor: markerInnerCircleColor, outerCircleRadius: markerOuterCircleRadius, outerCircleColor: markerOuterCircleColor)
        return createImageFromView(view)
    }
    
    /* Function to create a circular UIView that contains some string label.
     * This circular UIView will have a border of the specified size. */
    func createCircleViewWithLabel(label: String, innerCircleRadius: Double, innerCircleColor: UIColor, outerCircleRadius: Double, outerCircleColor: UIColor) -> UIView {
        // Create the outer circle circle.
        var outer = UIView()
        outer.frame = CGRectMake(0.0, 0.0, CGFloat(2.0 * outerCircleRadius), CGFloat(2.0 * outerCircleRadius))
        outer.backgroundColor = outerCircleColor
        outer.layer.cornerRadius = outer.frame.size.width / 2.0
        
        // Create the inner circle.
        var inner = UIView()
        inner.frame = CGRectMake(0.0, 0.0, CGFloat(2.0 * innerCircleRadius), CGFloat(2.0 * innerCircleRadius))
        inner.backgroundColor = innerCircleColor
        inner.layer.cornerRadius = inner.frame.size.width / 2.0
        
        // Create the text label.
        var text = UILabel(frame: inner.frame)
        text.text = label
        text.sizeToFit()
        
		// Center the text within the inner circle.
        inner.addSubview(text)
        text.center = inner.center
        
		// Center the inner circle within the outer circle.
        outer.addSubview(inner)
        inner.sizeToFit()
        inner.center = outer.center
        
        // Return the outer circle that now contains all the necessary child views.
        return outer
    }
    
    // MARK: Best Path functions
    
    func getDistance (loc1: CLLocation, loc2: CLLocation) -> Double {
        return loc1.distanceFromLocation(loc2)
    }
    
    func calculateDistances(coordinate: CLLocationCoordinate2D) {
        var newPos = allMarkers.count
        var distance = 0.0
        
        var location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        distance = getDistance(currentLocation, loc2: location)
        distances[CoordPair(coord1: currentLocation.coordinate, coord2: coordinate)] = distance
        
        for marker in allMarkers {
            var coord = marker.position
            distance = getDistance(CLLocation(latitude: coord.latitude, longitude: coord.longitude), loc2: location)
            distances[CoordPair(coord1: coord, coord2: coordinate)] = distance
        }
    }
    
    //wrapper for TSP variant
    func findBestPath() {
        
        var markers = Array<CLLocation>()
        
        for marker in allMarkers {
            markers.append(CLLocation(latitude:marker.position.latitude, longitude:marker.position.longitude))
        }
        
        var tsp = findTSP(markers, root : currentLocation)
        
        println(tsp.minDistance)
        orderedPath = tsp.minPath
//        for point in tsp.minPath {
//            for (index, marker) in enumerate(allMarkers) {
//                if (getDistance(CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude), loc2: point) < 1) {
//                    print("\(index + 1) ->")
//                }
//            }
//        }
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
    
    // MARK: Generic Helpers
    
    /* Helper function that removes an object from the specified array. */
    func removeObject<T: Equatable>(object: T, inout fromArray array: [T]) {
        var index = find(array, object)
        array.removeAtIndex(index!)
    }
}