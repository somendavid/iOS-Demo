//
//  RegisterViewController.swift
//  iOS Demo
//
//  Created by David Somen on 02/03/2015.
//  Copyright (c) 2015 David Somen. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let loginManager = LoginManager()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!

    @IBAction func registerButtonPressed(sender: UIButton) {
        loginManager.register(self.usernameTextField.text,
            password: self.passwordTextField.text,
            firstName: self.firstNameTextField.text,
            lastName: self.lastNameTextField.text)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
