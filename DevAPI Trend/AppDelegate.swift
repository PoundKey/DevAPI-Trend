//
//  AppDelegate.swift
//  DevAPI Trend
//
//  Created by Chang Tong Xue on 2016-01-17.
//  Copyright © 2016 DX. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        setSVHubStyle()
        setBarStyle()
        return true
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setSVHubStyle() {
        //SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.setBackgroundColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.75))
        SVProgressHUD.setForegroundColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
    func setBarStyle() {
        let color: UIColor = UIColor(red: 0.0 / 255, green: 94.0 / 255, blue: 170.0 / 255, alpha: 1)
        UINavigationBar.appearance().barStyle     = .Black
        UINavigationBar.appearance().translucent  = true
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().tintColor    = UIColor.whiteColor()
        
        let tabColor: UIColor = UIColor(red: 36.0 / 255, green: 116.0 / 255, blue: 180.0 / 255, alpha: 1)
        UITabBar.appearance().tintColor = tabColor
    }

}

