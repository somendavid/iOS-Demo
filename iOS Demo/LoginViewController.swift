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
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        self.loginManager.login(self.usernameTextField.text, password: self.passwordTextField.text)
    }
}
