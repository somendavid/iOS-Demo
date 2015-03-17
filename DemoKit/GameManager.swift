//
//  GameManager.swift
//  iOS Demo
//
//  Created by David Somen on 17/03/2015.
//  Copyright (c) 2015 David Somen. All rights reserved.
//

import GameKit

public class GameManager {
    
    public var localPlayer : GKLocalPlayer?
    
    private var viewController: UIViewController!
    
    public init(viewController: UIViewController!)
    {
        self.viewController = viewController
    }
    
    public func authenticateLocalPlayer()
    {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (viewController: UIViewController!, error: NSError!) in
            
            if(viewController != nil)
            {
                self.viewController.presentViewController(viewController, animated: true, completion: nil)
            }
            else if(localPlayer.authenticated)
            {
                self.localPlayer = localPlayer
            }
        }
    }
    
    public func reportAchievment()
    {
        GKAchievement.resetAchievementsWithCompletionHandler()
        {
            error in
            
            let achievment = GKAchievement(identifier: "ACH1")
            achievment.percentComplete = 100
            achievment.showsCompletionBanner = true
            
            GKAchievement.reportAchievements([achievment], withCompletionHandler: nil)
        }
    }
}
