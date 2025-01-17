//
//  AppDelegate.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 3/12/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import UIKit
import Parse
import HockeySDK

// CONSTANTS
let kLoggedInUsernameKey = "loggedInUsername"
let kShowMapPlottingInstructionsKey = "showMapPlottingInstructions"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let googleMapsApiKey = "AIzaSyDBaW5Ge4qCGOAL7liJ5FOGZapDeG90wAA"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
        // Make sure Google Maps has an API key too use
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        // Initialize Parse.
        Parse.setApplicationId("artI8N3mXYFbdiKS1Rl0oMpYgIDQ7YGJJefaevee", clientKey: "dCK914aozWYInkqGr50MiSNLOPcxQ3tpclIcJYRW")
        
        // Track statistics around application opens
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        // Integrate with HockeyApp
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("bbaee79da212add941fa70a1c67fbca7")
        BITHockeyManager.sharedHockeyManager().startManager()
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

