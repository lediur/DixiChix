//
//  ViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 3/12/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Text customized to welcome the user by username.
    @IBOutlet weak var welcomeUserLabel: UILabel!
    
    // Main Menu Buttons
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(kLoggedInUsernameKey)
        
        navigationController?.popToRootViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Welcome the user by their username.
        let defaults = NSUserDefaults.standardUserDefaults()
        if let loggedInUsername = defaults.stringForKey(kLoggedInUsernameKey) {
			welcomeUserLabel.text = "Welcome, \(loggedInUsername)!"
        } else {
            // Even though this shouldn't happen because this main menu VC should only be displayed once the user has logged in,
            // display something just in case we FSU.
            welcomeUserLabel.text = "Welcome!"
        }

        // Make the main menu buttons have rounded corners!
        startButton.layer.cornerRadius = startButton.frame.size.height / 4
        settingsButton.layer.cornerRadius = settingsButton.frame.size.height / 4
        aboutButton.layer.cornerRadius = aboutButton.frame.size.height / 4
        logoutButton.layer.cornerRadius = logoutButton.frame.size.height / 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

