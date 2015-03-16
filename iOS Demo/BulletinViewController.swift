import UIKit
import CloudKit

class BulletinViewController: UITableViewController, UITextFieldDelegate
{
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase

    var bulletins = [String]()

    var textField: UITextField?
    var timer: NSTimer?

    required init(coder aDecoder: NSCoder)
    {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase

        super.init(coder: aDecoder)

        subscribe()
        requestAccess()
    }

    func subscribe()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "NotificationRecieved", object: nil)

        let notification = CKNotificationInfo()
        notification.alertBody = "Bulletin Recieved!"

        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString + "create"
        let subscription = CKSubscription(recordType: "Reward", predicate: NSPredicate(value: true), subscriptionID: uuid, options: .FiresOnRecordCreation)

        subscription.notificationInfo = notification

        publicDB.saveSubscription(subscription)
        {
            subscription, error in

            self.handleError(error)
        }
    }

    func requestAccess()
    {
        container.requestApplicationPermission(.PermissionUserDiscoverability)
        {
            status, error in

            self.handleError(error)

            if status == .Granted
            {
                self.container.discoverAllContactUserInfosWithCompletionHandler()
                {
                    (userInfo: [AnyObject]!, error) in

                    self.handleError(error)

                    if (userInfo.isEmpty)
                    {
                        return
                    }

                    let me = userInfo.first as CKDiscoveredUserInfo

                    self.publicDB.fetchRecordWithID(me.userRecordID)
                    {
                        (userRecord: CKRecord!, error) in

                        userRecord.setObject(me.firstName, forKey: "firstName")
                        userRecord.setObject(me.lastName, forKey: "lastName")

                        self.publicDB.saveRecord(userRecord, nil)
                    }

                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.title = me.firstName + " " + me.lastName
                    }
                }
            }
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        addRefreshControl()
        refresh()
    }

    func addRefreshControl()
    {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
    }

    func refresh()
    {
        bulletins.removeAll(keepCapacity: false)

        let query = CKQuery(recordType: "Reward", predicate: NSPredicate(value: true))
        let sortDescriptor = NSSortDescriptor(key: "creationData", ascending: false)
        query.sortDescriptors = [sortDescriptor]

        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 10

        operation.recordFetchedBlock = {
            (record: CKRecord!) in

            self.bulletins.append(record.objectForKey("Title") as String)
        }

        operation.queryCompletionBlock = {
            cursor, error in

            self.handleError(error)

            dispatch_async(dispatch_get_main_queue())
            {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }

        publicDB.addOperation(operation)

        /*
        publicDB.performQuery(query, inZoneWithID: nil)
        {
            results, error in

            self.handleError(error)

            for result in results as [CKRecord]
            {
                self.bulletins.append(result.objectForKey("Title") as String)
            }

            dispatch_async(dispatch_get_main_queue())
            {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
        */
    }

    @IBAction func addButtonPressed(sender: AnyObject)
    {
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let doneAction = UIAlertAction(title: "Done", style: .Default)
        {
            action in

            if let title = self.textField?.text
            {
                let record = CKRecord(recordType: "Reward")
                record.setObject(title, forKey: "Title")
                record.setObject(NSDate(), forKey: "creationData")

                self.publicDB.saveRecord(record)
                {
                    record, error in

                    self.handleError(error)

                    self.bulletins.insert(title, atIndex: 0)

                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.tableView.reloadData()
                    }
                }
            }
        }

        let alert = UIAlertController(title: "Add Bulletin", message: nil, preferredStyle: .Alert)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        alert.addTextFieldWithConfigurationHandler()
        {
            (textField: UITextField!) in

            textField.delegate = self
            textField.autocapitalizationType = .Words

            self.textField = textField
        }

        presentViewController(alert, animated: true, completion: nil)
    }

    func handleError(error: NSError!)
    {
        if let error = error
        {
            let alertController = UIAlertController(title: nil, message: "CKErrorDomain \(error.code)", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))

            dispatch_async(dispatch_get_main_queue())
            {
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bulletins.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.textLabel?.text = bulletins[indexPath.row]

        return cell
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        return countElements(textField.text) < 30 || string == ""
    }
}

