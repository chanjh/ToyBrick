//
//  TBAppDelegate.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import UIKit
import UserNotifications

open class TBAppDelegate: UIResponder, UIApplicationDelegate {
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        TBModuleManager.shared.triggerEvent(.BHMSetupEvent)
        TBModuleManager.shared.triggerEvent(.BHMInitEvent)
        DispatchQueue.main.async {
            TBModuleManager.shared.triggerEvent(.BHMSplashEvent)
        }
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        #if DEBUG
        TBTimeProfiler.shared.saveTimeProfileDataIntoFile("BeeHiveTimeProfiler")
        #endif
        return true
    }

    open func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let item = BHShortcutItem(shortcutItem: shortcutItem, scompletionHandler: completionHandler)
        ToyBrick.shared.context?.touchShortcutItem = item
        TBModuleManager.shared.triggerEvent(.BHMQuickActionEvent)
    }
    
    open func applicationWillResignActive(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.BHMWillResignActiveEvent)
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.BHMDidEnterBackgroundEvent)
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.BHMWillEnterForegroundEvent)
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.BHMDidBecomeActiveEvent)
    }
    
    open func applicationWillTerminate(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.BHMWillTerminateEvent)
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let item = BHOpenURLItem(openURL: url, options: options)
        ToyBrick.shared.context?.openURLItem = item
        TBModuleManager.shared.triggerEvent(.BHMOpenURLEvent)
        return true
    }

    open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.BHMDidReceiveMemoryWarningEvent)
    }

    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        TBContext.shared.notificationsItem.error = error
        TBModuleManager.shared.triggerEvent(.BHMDidFailToRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        ToyBrick.shared.context?.notificationsItem.deviceToken = deviceToken
        TBModuleManager.shared.triggerEvent(.BHMDidRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        var notItem = ToyBrick.shared.context?.notificationsItem
        notItem?.userInfo = userInfo
        notItem?.notificationResultHander = completionHandler
        TBModuleManager.shared.triggerEvent(.BHMDidRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        ToyBrick.shared.context?.userActivityItem.userActivity = userActivity
        TBModuleManager.shared.triggerEvent(.BHMDidUpdateUserActivityEvent)
    }
    open func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        var item = ToyBrick.shared.context?.userActivityItem
        item?.userActivityType = userActivityType
        item?.userActivityError = error
        TBModuleManager.shared.triggerEvent(.BHMDidFailToContinueUserActivityEvent)
    }
    open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        ToyBrick.shared.context?.userActivityItem.userActivity = userActivity
        ToyBrick.shared.context?.userActivityItem.restorationHandler = restorationHandler
        TBModuleManager.shared.triggerEvent(.BHMContinueUserActivityEvent)
        return true
    }
    
    open func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        ToyBrick.shared.context?.userActivityItem.userActivityType = userActivityType
        TBModuleManager.shared.triggerEvent(.BHMWillContinueUserActivityEvent)
        return true
    }
    
    open func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        ToyBrick.shared.context?.watchItem = BHWatchItem(userInfo: userInfo, replyHandler: reply)
        TBModuleManager.shared.triggerEvent(.BHMHandleWatchKitExtensionRequestEvent)
    }
    
    open func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var notItem = ToyBrick.shared.context?.notificationsItem
        notItem?.notification = notification
        notItem?.notificationPresentationOptionsHandler = completionHandler
        notItem?.center = center
        TBModuleManager.shared.triggerEvent(.BHMWillPresentNotificationEvent)
    }
    
    open func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        var notItem = ToyBrick.shared.context?.notificationsItem
        notItem?.notificationResponse = response
        notItem?.notificationCompletionHandler = completionHandler
        notItem?.center = center
        TBModuleManager.shared.triggerEvent(.BHMDidReceiveNotificationResponseEvent)
    }
}

extension TBAppDelegate: UNUserNotificationCenterDelegate { }

typealias BHShortcutCompletionHandler = (Bool) -> Void
public struct BHShortcutItem {
    var shortcutItem: UIApplicationShortcutItem
    var scompletionHandler: BHShortcutCompletionHandler
}

public struct BHOpenURLItem {
    var openURL: URL
    var options: [UIApplication.OpenURLOptionsKey : Any]
}

typealias BHNotificationResultHandler = (UIBackgroundFetchResult) -> Void
typealias BHNotificationPresentationOptionsHandler = (UNNotificationPresentationOptions) -> Void
typealias BHNotificationCompletionHandler = () -> Void
public struct BHNotificationsItem {
    var error: Error?
    var deviceToken: Data?
    var userInfo: [AnyHashable : Any]?
    var notificationResultHander: BHNotificationResultHandler?
    var notification: UNNotification?
    var notificationPresentationOptionsHandler: BHNotificationPresentationOptionsHandler?
    var center: UNUserNotificationCenter?
    var notificationResponse: UNNotificationResponse?
    var notificationCompletionHandler: BHNotificationCompletionHandler?
}

typealias BHUserActivityRestorationHandler = ([UIUserActivityRestoring]?) -> Void
public struct BHUserActivityItem {
    var userActivity: NSUserActivity?
    var userActivityType: String?
    var userActivityError: Error?
    var restorationHandler: BHUserActivityRestorationHandler?
}

typealias BHWatchReplyHandler = ([AnyHashable : Any]?) -> Void
public struct BHWatchItem {
    var userInfo: [AnyHashable: Any]?
    var replyHandler: BHWatchReplyHandler?
}
