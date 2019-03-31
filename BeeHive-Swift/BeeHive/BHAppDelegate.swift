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

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let item = BHShortcutItem(shortcutItem: shortcutItem, scompletionHandler: completionHandler)
        BeeHive.shared.context?.touchShortcutItem = item
        BHModuleManager.shared.triggerEvent(.BHMQuickActionEvent)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMWillResignActiveEvent)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMDidEnterBackgroundEvent)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMWillEnterForegroundEvent)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMDidBecomeActiveEvent)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMWillTerminateEvent)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let item = BHOpenURLItem(openURL: url, options: options)
        BeeHive.shared.context?.openURLItem = item
        BHModuleManager.shared.triggerEvent(.BHMOpenURLEvent)
        return true
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMDidReceiveMemoryWarningEvent)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
}

extension BHAppDelegate: UNUserNotificationCenterDelegate {
    
}

typealias BHShortcutCompletionHandler = (Bool) -> Void

struct BHShortcutItem {
    var shortcutItem: UIApplicationShortcutItem
    var scompletionHandler: BHShortcutCompletionHandler
}

struct BHOpenURLItem {
    var openURL: URL
    var options: [UIApplication.OpenURLOptionsKey : Any]
}
