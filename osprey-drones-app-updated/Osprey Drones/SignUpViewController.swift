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
    	let mainMenuVC = storyboard?.instantiateViewControllerWithIdentifier("mainMenuViewController") as UIViewController
        navigationController?.pushViewController(mainMenuVC, animated: true)
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

