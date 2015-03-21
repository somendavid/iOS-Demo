//
//  TodayViewController.swift
//  DemoToday
//
//  Created by David Somen on 15/03/2015.
//  Copyright (c) 2015 David Somen. All rights reserved.
//

import UIKit
import NotificationCenter
import DemoKit

private let kCellHeight = 44

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!

    var users = [User]()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        users = LoginManager.sharedInstance.getAllUsers()!
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        preferredContentSize = CGSize(width: 0, height: kCellHeight * users.count)

        return users.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let user = users[indexPath.row]

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = user.fullName

        return cell
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!)
    {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
}
