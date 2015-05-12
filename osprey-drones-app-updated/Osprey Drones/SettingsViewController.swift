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
    
    @IBOutlet weak var instructionsSegmentedControl: UISegmentedControl!
    @IBAction func instructionsSegmentedControlIndexChanged(sender: AnyObject) {
		let defaults = NSUserDefaults.standardUserDefaults()
        switch instructionsSegmentedControl.selectedSegmentIndex
        {
        case 0:
        	defaults.setBool(true, forKey: kShowMapPlottingInstructionsKey)
        case 1:
        	defaults.setBool(false, forKey: kShowMapPlottingInstructionsKey)
        default:
            break
        }
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
        
        if let showInstructions = defaults.objectForKey(kShowMapPlottingInstructionsKey) as? Bool where showInstructions == false {
			instructionsSegmentedControl.selectedSegmentIndex = 1
        } else {
            instructionsSegmentedControl.selectedSegmentIndex = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

