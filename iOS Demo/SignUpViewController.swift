import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate
{
    let loginManager = LoginManager()
    
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

        self.loginManager.registerUsername(self.usernameTextField.text, password: self.passwordTextField.text,
                                           firstName: self.firstNameTextField.text, lastName: self.lastNameTextField.text)

        self.navigationController?.popViewControllerAnimated(true)
    }

    func checkValidation() -> Bool
    {
        if (self.usernameTextField.text.isEmpty || self.firstNameTextField.text.isEmpty ||
            self.lastNameTextField.text.isEmpty || self.passwordTextField.text.isEmpty)
        {
            self.showAlert("Please fill in all the fields")
            return false
        }
        else if (self.passwordTextField.text != self.repeatPasswordTextField.text)
        {
            self.showAlert("Passwords are not the same")
            return false
        }
        else if (self.loginManager.checkUsername(self.usernameTextField.text))
        {
            self.showAlert("Username already exists")
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
            case self.usernameTextField: self.firstNameTextField.becomeFirstResponder(); break
            case self.firstNameTextField: self.lastNameTextField.becomeFirstResponder(); break
            case self.lastNameTextField: self.passwordTextField.becomeFirstResponder(); break
            case self.passwordTextField: self.repeatPasswordTextField.becomeFirstResponder(); break
            case self.repeatPasswordTextField: self.register(); break
            default: break
        }

        return true
    }
}
