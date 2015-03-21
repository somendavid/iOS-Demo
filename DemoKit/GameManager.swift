import GameKit

public class GameManager
{
    public class var sharedInstance: GameManager
    {
        struct Static
        {
            static let instance: GameManager = GameManager()
        }

        return Static.instance
    }
    
    public var localPlayer: GKLocalPlayer?
    public var viewController: UIViewController?
    
    public func authenticateLocalPlayer()
    {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (viewController: UIViewController!, error: NSError!) in
            
            if (viewController != nil)
            {
                self.viewController?.presentViewController(viewController, animated: true, completion: nil)
            }
            else if (localPlayer.authenticated)
            {
                self.localPlayer = localPlayer
            }
        }
    }
    
    public func reportAchievment()
    {
        //GKAchievement.resetAchievementsWithCompletionHandler()
        //{
        //    error in

        let achievment = GKAchievement(identifier: "ACH1")
        achievment.percentComplete = 100
        achievment.showsCompletionBanner = true

        //    GKAchievement.reportAchievements([achievment], withCompletionHandler: nil)
        //}
    }
}
