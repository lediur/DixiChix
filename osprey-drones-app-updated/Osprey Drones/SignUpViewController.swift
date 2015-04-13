//
//  SignUpViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 4/3/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let enteredUsername = usernameTextField.text
        let enteredPassword = passwordTextField.text
        
        // Do not let user sign up with an empty username or an empty password field.
        // Also do not let the user sign up if the username contains whitespace.
        if (enteredUsername.isEmpty || enteredPassword.isEmpty) {
            let errorAlert = GeneralUtils.createAlertWithMessage("Username and password must not be empty!", title: "Login Error", buttonTitle: "OK")
            self.presentViewController(errorAlert, animated: true, completion: nil)
            return
        } else if (GeneralUtils.stringContainsWhitespace(enteredUsername)) {
            let errorAlert = GeneralUtils.createAlertWithMessage("Your proposed username cannot contain whitespace!", title: "Username Error", buttonTitle: "OK")
            self.presentViewController(errorAlert, animated: true, completion: nil)
            return
        }
        
        var user = PFUser()
		user.username = enteredUsername
		user.password = enteredPassword

		user.signUpInBackgroundWithBlock {
			(succeeded, error) in
			
			if error == nil {
                // Sign up was successful
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(enteredUsername, forKey: kLoggedInUsernameKey)
                
                // Bring user to the main menu now that they are logged in.
                if let mainMenuVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainMenuViewController") as? UIViewController {
                    self.navigationController?.pushViewController(mainMenuVC, animated: true)
                }
			} else {
                var errorMessage = "There was an error signing up."
                
                // If we can get something more specific from the NSError, set the error message to that message instead.
                if let errorUserInfo = error?.userInfo, let errorUserInfoString = errorUserInfo["error"] as? String {
                    errorMessage = errorUserInfoString.properlyCapitalizedSentence
                }
                
                let errorAlert = GeneralUtils.createAlertWithMessage(errorMessage, title: "Sign Up Error", buttonTitle: "OK")
                self.presentViewController(errorAlert, animated: true, completion: nil)
			}
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make our buttons have rounded corners!
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 4
        signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 5
        
        // So that when the user taps on "Done" when editing the username/password text fields, we can detect it and dismiss the keyboard
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // When the user taps on the view, we should dismiss the keyboard
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

