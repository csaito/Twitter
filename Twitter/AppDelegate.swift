
//
//  AppDelegate.swift
//  Twitter
//
//  Created by Chihiro Saito on 10/26/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if (User.currentUser != nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TimelineNavigationController")
            //window?.rootViewController = vc
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UserDidLogout"), object: nil, queue: OperationQueue.main) { (Notification) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("\(url.description)");
        if (url.scheme == "twitterdemo") {
            TwitterClient.sharedInstance.loginCallback(query: url.query!)
            /**
            let requestToken = BDBOAuth1Credential(queryString: url.query!)
            
            let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string:"https://api.twitter.com")!,
                                                        consumerKey: "c5NUWp3Mc4ixfqtqneEcHNs9Q", consumerSecret: "8qjdoXPxS8yLnLO8px0FpIVk42MsskYgFvtv8F9saA2kGiCICO")
            
            twitterClient?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (token: BDBOAuth1Credential?) -> Void  in
                    print("Got access token!")
                
                twitterClient?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
                                   success:
                                    { (task:URLSessionDataTask, response:Any?) -> Void in
                                        
                                        let user = response as! NSDictionary
                                        print("name: \(user["name"])")
                                        
                    }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
                        print("error: \(error.localizedDescription)")
                    })
                }
                , failure:{ (error: Error?) in
                    print("error: \(error!.localizedDescription)")
            })
 **/
            
        }
        return true
    }

}

