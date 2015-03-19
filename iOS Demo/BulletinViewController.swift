import UIKit
import CloudKit
import DemoKit

class BulletinViewController: UITableViewController, UITextFieldDelegate
{
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase

    var bulletins = [String]()
    let kBulletinLimit = 10
    let kBulletinTitleCharLimit = 30

    var titleTextField: UITextField?
    var messageTextField: UITextField?
    
    var sendAction: UIAlertAction?
    
    var initials: String?
    
    var gameManager : GameManager!

    required init(coder aDecoder: NSCoder)
    {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
        super.init(coder: aDecoder)

        gameManager = GameManager(viewController: self)
        gameManager.authenticateLocalPlayer()
        
        subscribe()
        requestAccess()
    }

    func subscribe()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "NotificationRecieved", object: nil)

        let notification = CKNotificationInfo()
        notification.alertBody = "New Bulletin Recieved!"
        notification.soundName = "dingding.aif"

        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString + "create"
        let subscription = CKSubscription(recordType: "Bulletin", predicate: NSPredicate(value: true), subscriptionID: uuid, options: .FiresOnRecordCreation)

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
                self.container.fetchUserRecordIDWithCompletionHandler()
                {
                    (recordId: CKRecordID!, error) in

                    self.container.discoverUserInfoWithUserRecordID(recordId)
                    {
                        (userInfo: CKDiscoveredUserInfo!, error) in
                            
                        self.handleError(error)
                            
                        self.publicDB.fetchRecordWithID(userInfo.userRecordID)
                        {
                            (userRecord: CKRecord!, error) in
                            
                            self.handleError(error)
                            
                            userRecord.setObject(userInfo.firstName, forKey: "firstName")
                            userRecord.setObject(userInfo.lastName, forKey: "lastName")
                                    
                            self.publicDB.saveRecord(userRecord, nil)
                            
                            self.initials = self.getInitials(userRecord)
                        }
                            
                        dispatch_async(dispatch_get_main_queue())
                        {
                            self.title = userInfo.firstName + " " + userInfo.lastName
                        }
                    }
                }
            }
        }
    }
    
    func getInitials(userRecord: CKRecord) -> String
    {
        let firstName = userRecord.objectForKey("firstName") as String
        let lastName = userRecord.objectForKey("lastName") as String
        
        let firstInitial = first(firstName)
        let lastInitial = first(lastName)

        return String(firstInitial!) + String(lastInitial!)
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

        let query = CKQuery(recordType: "Bulletin", predicate: NSPredicate(value: true))
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        query.sortDescriptors = [sortDescriptor]

        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 10

        operation.recordFetchedBlock = {
            (record: CKRecord!) in

            let title = record.objectForKey("title") as String
            
            self.publicDB.fetchRecordWithID(record.creatorUserRecordID)
            {
                (userRecord: CKRecord!, error) in
                    
                self.handleError(error)
             
                let fullTitle = self.getInitials(userRecord) + " - " + title
                
                self.bulletins.append(fullTitle)
                
                dispatch_async(dispatch_get_main_queue())
                {
                    self.tableView.reloadData()
                }
            }
        }

        operation.queryCompletionBlock = {
            cursor, error in

            self.handleError(error)

            dispatch_async(dispatch_get_main_queue())
            {
                self.refreshControl!.endRefreshing()
            }
        }

        publicDB.addOperation(operation)
    }

    @IBAction func addButtonPressed(sender: AnyObject)
    {
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        sendAction = UIAlertAction(title: "Send", style: .Default)
        {
            action in

            let title = self.titleTextField?.text
            let message = self.messageTextField?.text
            
            let record = CKRecord(recordType: "Bulletin")
            record.setObject(title, forKey: "title")
            record.setObject(message, forKey: "message")

            self.publicDB.saveRecord(record)
            {
                record, error in

                self.handleError(error)

                let fullTitle = self.initials! + " - " + title!

                self.bulletins.insert(fullTitle, atIndex: 0)

                    self.bulletins.insert(fullTitle, atIndex: 0)

                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.tableView.reloadData()
                        
                        self.gameManager.reportAchievment()
                    }
                }
            }
        }
        sendAction?.enabled = false

        let alert = UIAlertController(title: nil, message: "Add Bulletin", preferredStyle: .Alert)
        alert.addAction(cancelAction)
        alert.addAction(sendAction!)
        
        alert.addTextFieldWithConfigurationHandler()
        {
            (textField: UITextField!) in

            textField.placeholder = "Title"
            textField.delegate = self
            textField.autocapitalizationType = .Words

            self.titleTextField = textField
        }
        
        alert.addTextFieldWithConfigurationHandler()
        {
            (textField: UITextField!) in
                
            textField.placeholder = "Message"
            textField.delegate = self
            textField.autocapitalizationType = .Words
                
            self.messageTextField = textField
        }

        presentViewController(alert, animated: true, completion: nil)
    }

    func handleError(error: NSError!)
    {
        if let error = error
        {
            let alertController = UIAlertController(title: "CKErrorDomain \(error.code)", message: "Please inform yours truly of the conditions that led to this unfortunate oopsie daisy.", preferredStyle: .Alert)
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
        let count = countElements(textField.text)
    
        //sendAction?.enabled = count != 0
        
        return count < kBulletinTitleCharLimit || string == ""
    }
}

