import UIKit
import DemoKit

class SignUpViewController: ScrollViewControllerBase
{
    let loginManager = LoginManager.sharedInstance
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!

    @IBAction func registerButtonPressed(sender: UIButton)
    {
        self.register()
    }

    func register()
    {
        if (!self.checkValidation())
        {
            return
        }

        loginManager.registerUsername(usernameTextField.text, password: passwordTextField.text,
                                           firstName: firstNameTextField.text, lastName: lastNameTextField.text)

        self.navigationController?.popViewControllerAnimated(true)
    }

    func checkValidation() -> Bool
    {
        if (usernameTextField.text.isEmpty || firstNameTextField.text.isEmpty ||
            lastNameTextField.text.isEmpty || passwordTextField.text.isEmpty)
        {
            showAlert("Please fill in all the fields")
            return false
        }
        else if (passwordTextField.text != repeatPasswordTextField.text)
        {
            showAlert("Passwords are not the same")
            return false
        }
        else if (loginManager.checkUsername(usernameTextField.text))
        {
            showAlert("Username already exists")
            return false
        }

        return true
    }

    func showAlert(message: String)
    {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        switch textField
        {
            case usernameTextField: firstNameTextField.becomeFirstResponder(); break
            case firstNameTextField: lastNameTextField.becomeFirstResponder(); break
            case lastNameTextField: passwordTextField.becomeFirstResponder(); break
            case passwordTextField: repeatPasswordTextField.becomeFirstResponder(); break
            case repeatPasswordTextField: register(); break
            default: break
        }

        return true
    }
}
