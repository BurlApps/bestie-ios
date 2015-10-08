//
//  AppDelegate.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/23/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit
import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Initialize Parse
        let credentials = Globals.parseCredentials()
        ParseCrashReporting.enable()
        PFUser.enableRevocableSessionInBackground()
        Parse.setApplicationId(credentials[0], clientKey: credentials[1])
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        let mixpanel = Mixpanel.sharedInstanceWithToken(Globals.mixpanelToken())
        mixpanel.miniNotificationPresentationTime = 10
        mixpanel.identify(mixpanel.distinctId)
        
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        if application.applicationState != UIApplicationState.Background {
            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(Selector("application:didReceiveRemoteNotification:fetchCompletionHandler:"))
            let noPushPayload = (launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] == nil)
            
            if preBackgroundPush || oldPushHandlerOnly || noPushPayload {
                PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
                mixpanel.track("Mobile.App.Open")
            }
        }
        
        // Update Config
        Config.update(nil)

        // Create Installation
        Installation.startup()
        
        // Configure Settings Panel
        let versionBuild = Globals.appBuildVersion()
        StateTracker.setVersion(versionBuild)
    
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Installation.current().setDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        var wasActive = true
        var actions: [String]!
        
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: nil)
            Mixpanel.sharedInstance().trackPushNotification(userInfo)
            wasActive = false
        }
        
        if let tempActions = userInfo["actions"] as? String {
            actions = tempActions.componentsSeparatedByString(",")
        } else if let tempAction = userInfo["action"] as? String {
            actions = [tempAction]
        }
        
        if actions != nil && !actions.isEmpty {
            for (var action) in actions {
                var message = userInfo["message"] as? String
                
                action = action.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                switch(action) {
                    case "batch.reload":
                        Installation.current().decrementBadge()
                        
                        if wasActive {
                            Globals.reloadBatch()
                            Globals.showBatchAlert()
                        } else {
                            Globals.slideToBatchScreen()
                        }
                    
                    default: print(action)
                }
            }
        }
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Globals.reloadBatch()
        Config.update(nil)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
