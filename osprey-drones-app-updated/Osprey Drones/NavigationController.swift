//
//  NavigationController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 4/3/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (userIsLoggedIn()) {
            if let mainMenuVC = storyboard?.instantiateViewControllerWithIdentifier("mainMenuViewController") as? UIViewController, let loginVC = storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as? UIViewController {
                pushViewController(loginVC, animated: true)
                pushViewController(mainMenuVC, animated: true)
            }
        } else {
            if let loginVC = storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as? UIViewController {
                pushViewController(loginVC, animated: true)
            }
        }
        
    }
    
    private func userIsLoggedIn() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let loggedInUsername = defaults.stringForKey(kLoggedInUsernameKey) {
            return true
        }
        
        return false
    }

}
