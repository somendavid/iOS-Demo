import UIKit

class UserViewController: UIViewController
{
    @IBOutlet weak var firstNameLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.title = self.user.username
        self.firstNameLabel.text = self.user.firstname + " " + self.user.lastname
        
        if(user.username == "davidsomen")
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Admin", style: .Plain, target: self, action: "showUser")
        }
    }
    
    func showUser()
    {
        self.performSegueWithIdentifier("LookupTableViewController", sender: self)
    }
}
