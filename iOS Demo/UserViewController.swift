//
//  UserViewController.swift
//  iOS Demo
//
//  Created by David Somen on 03/03/2015.
//  Copyright (c) 2015 David Somen. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.user?.username
        self.firstNameLabel.text = self.user.firstname + " " + self.user.lastname
    }
}
