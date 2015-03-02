//
//  User.swift
//  iOS Demo
//
//  Created by David Somen on 02/03/2015.
//  Copyright (c) 2015 David Somen. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var firstname: String
    @NSManaged var lastname: String
    @NSManaged var age: NSNumber

}
