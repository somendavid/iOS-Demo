import Foundation
import CoreData

@objc (User)
class User: NSManagedObject
{
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var firstname: String
    @NSManaged var lastname: String
    @NSManaged var age: NSNumber

}
