import UIKit
import DemoKit

private let kBulletinTitleCharLimit = 30

class BulletinViewController: UITableViewController, BulletinManagerDelegate, UITextFieldDelegate
{
    var titleTextField: UITextField!
    var messageTextField: UITextField!
    var sendAction: UIAlertAction!

    var gameManager = GameManager.sharedInstance
    var bulletinManager = BulletinManager.sharedInstance

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        bulletinManager.delegate = self

        gameManager.viewController = self
        gameManager.authenticateLocalPlayer()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupRefreshControl()

        bulletinManager.subscribe()
        bulletinManager.requestAccess()
        {
            (fullName: String?) in

            if let fn = fullName
            {
                self.title = fn
            }
        }

        refresh()
    }

    func setupRefreshControl()
    {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
    }

    func refresh()
    {
        bulletinManager.refresh()
        {
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
    }

    @IBAction func addButtonPressed(sender: AnyObject)
    {
        presentViewController(addBulletinAlertController, animated: true, completion: nil)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bulletinManager.bulletins.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.textLabel?.text = bulletinManager.bulletins[indexPath.row]

        return cell
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let count = countElements(textField.text)

        //sendAction?.enabled = count != 0

        return count < kBulletinTitleCharLimit || string == ""
    }

    func showMessage(message: String)
    {
        var alertController = messageAlertController
        alertController.message = message
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    lazy var addBulletinAlertController: UIAlertController! = {
        [unowned self] in

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        self.sendAction = UIAlertAction(title: "Send", style: .Default)
        {
            action in

            let title = self.titleTextField.text
            let message = self.messageTextField.text

            self.bulletinManager.addBulletin(title, message: message)
            {
                self.tableView.reloadData()
                self.gameManager.reportAchievment()
            }
        }
        //sendAction?.enabled = false

        let alertController = UIAlertController(title: nil, message: "Add Bulletin", preferredStyle: .Alert)
        alertController.addAction(cancelAction)
        alertController.addAction(self.sendAction!)
        alertController.addTextFieldWithConfigurationHandler()
        {
            (textField: UITextField!) in

            textField.placeholder = "Title"
            textField.delegate = self
            textField.autocapitalizationType = .Words

            self.titleTextField = textField
        }
        alertController.addTextFieldWithConfigurationHandler()
        {
            (textField: UITextField!) in

            textField.placeholder = "Message"
            textField.delegate = self
            textField.autocapitalizationType = .Words

            self.messageTextField = textField
        }

        return alertController
    }()

    lazy var messageAlertController: UIAlertController = {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .Alert)

        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: .Default,
                                                handler: nil))

        return alertController
    }()
}

