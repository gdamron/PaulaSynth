//
//  AppDelegate.swift
//  AudioEngine2
//
//  Created by Grant Damron on 2/16/15.
//  Copyright (c) 2015 Grant Damron. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserSettings.sharedInstance.load()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        UserSettings.sharedInstance.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UserSettings.sharedInstance.load()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserSettings.sharedInstance.save()
    }


}

