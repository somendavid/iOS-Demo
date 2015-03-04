import UIKit

class LoginViewController: UIViewController
{
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let loginManager = LoginManager()
    let userSegueIdentifier = "UserViewController"
    var loginUser: User?
    
    @IBAction func loginButtonPressed(sender: UIButton)
    {
        login()
    }

    func login()
    {
        if let user = self.loginManager.loginUsername(self.usernameTextField.text, password: self.passwordTextField.text)
        {
            self.loginUser = user
            self.performSegueWithIdentifier(userSegueIdentifier, sender: self)
        }
        else
        {
            showAlert()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == userSegueIdentifier
        {
            let viewController = segue.destinationViewController as UserViewController
            viewController.user = self.loginUser
        }
    }

    func showAlert()
    {
        let alertController = UIAlertController(title: "Login Failed", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        switch textField
        {
            case self.usernameTextField: self.passwordTextField.becomeFirstResponder(); break
            case self.passwordTextField: login(); break
            default: break
        }

        return true
    }
}