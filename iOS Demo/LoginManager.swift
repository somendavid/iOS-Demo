import UIKit
import CoreData

public class LoginManager
{
    public class var sharedInstance: LoginManager
    {
        struct Static
        {
            static let instance: LoginManager = LoginManager()
        }

        return Static.instance
    }

    let managedObjectContext = DataManager.sharedInstance.managedObjectContext!

    public func loginUsername(username: String, password: String) -> User?
    {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        if let result = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [User]
        {
            return result.first
        }
        
        return nil;
    }

    public func checkUsername(username: String) -> Bool
    {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        if let result = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [User]
        {
            return !result.isEmpty
        }

        return false
    }
    
    public func registerUsername(username: String, password: String, firstName: String, lastName: String)
    {
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as User
        
        newUser.username = username
        newUser.password = password
        newUser.firstname = firstName
        newUser.lastname = lastName
        
        managedObjectContext.save(nil)
    }
    
    public func getAllUsers() -> [User]?
    {
        let fetchRequest = NSFetchRequest(entityName: "User")

        if let result = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [User]
        {
            return result
        }
        
        return nil
    }
}
