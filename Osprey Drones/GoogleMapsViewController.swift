//
//  GoogleMapsViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 3/12/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import Foundation

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    var allMarkers: [GMSMarker] = []
    let markerInnerCircleRadius = 12.0
    let markerInnerCircleColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let markerOuterCircleRadius = 14.0
	let markerOuterCircleColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let markerTitleText = "Tap To Delete!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
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
            mapView.settings.myLocationButton = true
        }
    }
    
    /* Executes when the location manager receives new location data. */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            // This updates the map's camera to center around the user's current location. The GMSCameraPosition class
            // aggregates all camera position parameters and passes them to the map for display.
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // Tell locationManager we are no longer interested in updates. Initial location is enough to work with for now.
            locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: GMSMapViewDelegate methods
    
    /* When the user holds a long press on the map, draw a numbered marker there.
     * This numbered marker can be deleted by tapping the marker and then tapping
     * the info window that clearly states "Tap to Delete!" */
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {

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
    }

    /* When the user taps on the info window, remove the marker that was tapped, and refresh
     * all the markers so that they are appropriately numbered. */
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
    	marker.map = nil
        removeObject(marker, fromArray: &allMarkers)
        refreshMapMarkers()
    }
    
    // MARK: Maps Helper functions

    /* Refreshes the markers so that they are appropriately numbered. Called after
     * markers are removed from the array. */
    func refreshMapMarkers() {
        for (index, marker) in enumerate(allMarkers) {
            var label = "\(index + 1)"
            marker.icon = createCircleImageWithLabel(label)
        }
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
    
    // MARK: Generic Helpers
    
    /* Helper function that removes an object from the specified array. */
    func removeObject<T: Equatable>(object: T, inout fromArray array: [T]) {
        var index = find(array, object)
        array.removeAtIndex(index!)
    }
}