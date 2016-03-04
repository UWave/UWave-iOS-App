//
//  AppDelegate.swift
//  UWave-IOS
//
//  Created by George Urick on 12/16/15.
//  Copyright © 2015 HappinessDevelopment. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppiraterDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //initializes UWRadioPlayer
        UWRadioPlayer.sharedInstance()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        let appId = NSBundle.mainBundle().objectForInfoDictionaryKey("iTunes app ID") as! String
        
        if (defaults.valueForKey("rateThisAppTimeBeforeReminding") == nil) {
            defaults.setValue(2, forKey: "rateThisAppTimeBeforeReminding")
        }
        
        Appirater.setDelegate(self)
        Appirater.setAppId(appId)
        Appirater.appLaunched(true)
        Appirater.setDebug(true)
        Appirater.setDaysUntilPrompt(7)
        Appirater.setUsesUntilPrompt(5)
        Appirater.setSignificantEventsUntilPrompt(10)
        Appirater.setTimeBeforeReminding(defaults.valueForKey("rateThisAppTimeBeforeReminding") as! Double)
        
        
        // Override point for customization after application launch.
        return true
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func appiraterDidOptToRemindLater(appirater: Appirater!) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let currentTimeToRemind = defaults.valueForKey("rateThisAppTimeBeforeReminding") as! Double
        let newTimeToRemind = currentTimeToRemind * 2
        defaults.setValue(newTimeToRemind, forKey: "rateThisAppTimeBeforeReminding")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        Appirater.appEnteredForeground(true)
        UWRadioPlayer.sharedInstance().didEnterBackground = true
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName(UWNewSongNotification, object: nil)
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName(UWNewSongNotification, object: nil)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        if (event?.type == .RemoteControl) {
            if (event?.subtype == .RemoteControlPause) {
                UWRadioPlayer.sharedInstance().pause()
            }
            else if (event?.subtype == .RemoteControlPlay) {
                UWRadioPlayer.sharedInstance().play()
            }
            else if (event?.subtype == .RemoteControlTogglePlayPause) {
                UWRadioPlayer.sharedInstance().toggle()
            }
            else if (event?.subtype == .RemoteControlStop) {
                UWRadioPlayer.sharedInstance().pause()
            }
        }
    }


}

