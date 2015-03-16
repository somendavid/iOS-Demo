import UIKit
import CoreData

public class LoginManager
{
    let dataManager = DataManager()
    let managedObjectContext: NSManagedObjectContext
    
    public init()
    {
        self.managedObjectContext = dataManager.managedObjectContext!
    }

    public func loginUsername(username: String, password: String) -> User?
    {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        if let result = self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [User]
        {
            return result.first
        }
        
        return nil;
    }

    public func checkUsername(username: String) -> Bool
    {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        if let result = self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [User]
        {
            return !result.isEmpty
        }

        return false
    }
    
    public func registerUsername(username: String, password: String, firstName: String, lastName: String)
    {
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.managedObjectContext) as User
        
        newUser.username = username
        newUser.password = password
        newUser.firstname = firstName
        newUser.lastname = lastName
        
        self.managedObjectContext.save(nil)
    }
    
    public func getAllUsers() -> [User]?
    {
        let fetchRequest = NSFetchRequest(entityName: "User")

        if let result = self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [User]
        {
            return result
        }
        
        return nil
    }
}
