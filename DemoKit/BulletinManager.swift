import CloudKit

private let kBulletinLimit = 10

public protocol BulletinManagerDelegate
{
    func showMessage(message: String)
}

public class BulletinManager
{
    public class var sharedInstance: BulletinManager
    {
        struct Static
        {
            static let instance: BulletinManager = BulletinManager()
        }

        return Static.instance
    }

    public var bulletins = [String]()
    public var delegate: BulletinManagerDelegate?

    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase

    var initials: String?

    public init()
    {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: "refresh",
                                                         name: "NotificationRecieved",
                                                         object: nil)
    }

    public func subscribe()
    {
        let notification = CKNotificationInfo()
        notification.alertBody = "New Bulletin Recieved!"
        notification.soundName = "dingding.aif"

        let subscription = CKSubscription(recordType: "Bulletin",
                                          predicate: NSPredicate(value: true),
                                          options: .FiresOnRecordCreation)

        subscription.notificationInfo = notification

        publicDB.saveSubscription(subscription)
        {
            subscription, error in

            self.handleError(error)
        }
    }

    public func requestAccess(completionHandler: ((String?) -> Void))
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

                            dispatch_async(dispatch_get_main_queue())
                            {
                                completionHandler(userInfo.firstName + " " + userInfo.lastName)
                            }
                        }
                    }
                }
            }
        }
    }

    public func refresh(completionHandler: (() -> Void))
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

                dispatch_async(dispatch_get_main_queue())
                {
                    self.handleError(error)
                }

                let fullTitle = self.getInitials(userRecord) + " - " + title

                self.bulletins.append(fullTitle)
            }
        }

        operation.queryCompletionBlock = {
            cursor, error in

            dispatch_async(dispatch_get_main_queue())
            {
                self.handleError(error)
                completionHandler()
            }
        }

        publicDB.addOperation(operation)
    }

    public func addBulletin(title: String, message: String, completionHandler: (() -> Void))
    {
        let record = CKRecord(recordType: "Bulletin")
        record.setObject(title, forKey: "title")
        record.setObject(message, forKey: "message")

        self.publicDB.saveRecord(record)
        {
            record, error in

            dispatch_async(dispatch_get_main_queue())
            {
                self.handleError(error)
            }
            
            var fullTitle = title
            if let i = self.initials
            {
                fullTitle = i + " - " + title
            }

            self.bulletins.insert(fullTitle, atIndex: 0)

            dispatch_async(dispatch_get_main_queue())
            {
                completionHandler()
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

    func handleError(error: NSError!)
    {
        if let e = error
        {
            self.delegate?.showMessage("CKErrorDomain \(e.code)")
        }
    }
}