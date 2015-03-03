//
//  LoginManager.swift
//  iOS Demo
//
//  Created by David Somen on 02/03/2015.
//  Copyright (c) 2015 David Somen. All rights reserved.
//

import UIKit
import CoreData

class LoginManager {
    
    let managedObjectContext : NSManagedObjectContext
    
    init()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext!
    }

    func login(username:String, password:String) -> User? {
        
        let fetchRequest = NSFetchRequest(entityName:"User")
        fetchRequest.predicate = NSPredicate(format:"username == %@ AND password == %@", username, password)
        
        if let result = self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [User] {
            return result.first
        }
        
        return nil;
    }
    
    func register(username:String, password:String, firstName:String, lastName:String) {
        
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.managedObjectContext) as User
        
        newUser.username = username
        newUser.password = password
        newUser.firstname = firstName
        newUser.lastname = lastName
        
        self.managedObjectContext.save(nil)
    }
}
