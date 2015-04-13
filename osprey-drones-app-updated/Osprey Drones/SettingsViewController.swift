//
//  SettingsViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 3/23/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var droneSpeedLabel: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    @IBAction func speedSliderChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setFloat(speedSlider.value, forKey: "droneSpeedKey")
        
        let droneSpeed = NSString(format:"%.1f", speedSlider.value)
        droneSpeedLabel.text = "Drone Speed: \(droneSpeed) m/s"
    }

    @IBAction func homeButtonPressed(sender: AnyObject) {
    	navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Grab the saved drone speed, or just set it to the default value if the
        // user has not changed it.
        let defaults = NSUserDefaults.standardUserDefaults()
        if let droneSpeed = defaults.objectForKey("droneSpeedKey") as? Float {
            let droneSpeedStr = NSString(format:"%.1f", droneSpeed)
            droneSpeedLabel.text = "Drone Speed: \(droneSpeedStr) m/s"
            speedSlider.value = droneSpeed
        } else {
            let droneSpeed = NSString(format:"%.1f", speedSlider.value)
            droneSpeedLabel.text = "Drone Speed: \(droneSpeed) m/s"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

