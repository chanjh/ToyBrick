//
//  BHAppDelegate.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import UIKit
import UserNotifications

class BHAppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BHModuleManager.shared.triggerEvent(.BHMSetupEvent)
        BHModuleManager.shared.triggerEvent(.BHMInitEvent)
        DispatchQueue.main.async {
            BHModuleManager.shared.triggerEvent(.BHMSplashEvent)
        }
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        #if DEBUG
        BHTimeProfiler.shared.saveTimeProfileDataIntoFile("BeeHiveTimeProfiler")
        #endif
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

extension BHAppDelegate: UNUserNotificationCenterDelegate {
    
}
