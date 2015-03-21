//
//  AppDelegate.swift
//  iOS Demo
//
//  Created by David Somen on 02/03/2015.
//  Copyright (c) 2015 David Somen. All rights reserved.
//

import UIKit
import DemoKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool
    {
        let notification = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: nil)
        application.registerUserNotificationSettings(notification)
        application.registerForRemoteNotifications()
        
        return true
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject:AnyObject])
    {
        NSNotificationCenter.defaultCenter().postNotificationName("NotificationRecieved", object: nil)
    }

    func applicationWillTerminate(application: UIApplication)
    {
        DataManager.sharedInstance.saveContext()
    }
}

