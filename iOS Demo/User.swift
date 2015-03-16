import Foundation
import CoreData

@objc (User)
public class User: NSManagedObject
{
    @NSManaged public var username: String
    @NSManaged public var password: String
    @NSManaged public var firstname: String
    @NSManaged public var lastname: String

    public var fullName: String
    {
        get
        {
            return firstname + " " + lastname
        }
    }
}
