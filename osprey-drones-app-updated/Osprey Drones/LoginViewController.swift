//
//  LoginViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 4/3/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let enteredUsername = usernameTextField.text
        let enteredPassword = passwordTextField.text
        
        PFUser.logInWithUsernameInBackground(enteredUsername, password: enteredPassword) {
            (user, error) in
            if user != nil {
                // Login was successful
                println("Hooray! You logged in successfully!")
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(enteredUsername, forKey: kLoggedInUsernameKey)
                
                // Bring user to the main menu now that they are logged in.
                let mainMenuVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainMenuViewController") as UIViewController
                self.navigationController?.pushViewController(mainMenuVC, animated: true)
            } else {
                println("Boo! There was an error logging in!")
                println(error.userInfo)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make our buttons have rounded corners!
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 5
        signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 4
        
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
