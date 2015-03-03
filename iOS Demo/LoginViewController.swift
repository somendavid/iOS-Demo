//
//  LoginViewController.swift
//  iOS Demo
//
//  Created by David Somen on 02/03/2015.
//  Copyright (c) 2015 David Somen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let loginManager = LoginManager()
    var loginUser : User?
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        if let user = self.loginManager.login(self.usernameTextField.text, password: self.passwordTextField.text) {
            self.loginUser = user
            self.performSegueWithIdentifier("UserViewController", sender: self)
        }
        else
        {
            showAlert()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UserViewController" {
            let viewController = segue.destinationViewController as UserViewController
            viewController.user = self.loginUser
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Login Failed", message: nil, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {}
    }
}