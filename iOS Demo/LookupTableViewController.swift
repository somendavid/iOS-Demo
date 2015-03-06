//
//  LookupTableViewController.swift
//  iOS Demo
//
//  Created by David Somen on 05/03/2015.
//  Copyright (c) 2015 David Somen. All rights reserved.
//

import UIKit

class LookupTableViewController: UITableViewController {

    let loginManager = LoginManager()
    var users : Array<User> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        users = loginManager.getAllUsers()!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = user.username
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserViewController") as UserViewController
        viewController.user = users[indexPath.row]
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}