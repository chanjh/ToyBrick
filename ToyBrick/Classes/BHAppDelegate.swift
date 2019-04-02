//
//  BHAppDelegate.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import UIKit
import UserNotifications

open class BHAppDelegate: UIResponder, UIApplicationDelegate {
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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

    open func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let item = BHShortcutItem(shortcutItem: shortcutItem, scompletionHandler: completionHandler)
        BeeHive.shared.context?.touchShortcutItem = item
        BHModuleManager.shared.triggerEvent(.BHMQuickActionEvent)
    }
    
    open func applicationWillResignActive(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMWillResignActiveEvent)
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMDidEnterBackgroundEvent)
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMWillEnterForegroundEvent)
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMDidBecomeActiveEvent)
    }
    
    open func applicationWillTerminate(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMWillTerminateEvent)
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let item = BHOpenURLItem(openURL: url, options: options)
        BeeHive.shared.context?.openURLItem = item
        BHModuleManager.shared.triggerEvent(.BHMOpenURLEvent)
        return true
    }

    open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        BHModuleManager.shared.triggerEvent(.BHMDidReceiveMemoryWarningEvent)
    }

    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        BHContext.shared.notificationsItem.error = error
        BHModuleManager.shared.triggerEvent(.BHMDidFailToRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BeeHive.shared.context?.notificationsItem.deviceToken = deviceToken
        BHModuleManager.shared.triggerEvent(.BHMDidRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        var notItem = BeeHive.shared.context?.notificationsItem
        notItem?.userInfo = userInfo
        notItem?.notificationResultHander = completionHandler
        BHModuleManager.shared.triggerEvent(.BHMDidRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        BeeHive.shared.context?.userActivityItem.userActivity = userActivity
        BHModuleManager.shared.triggerEvent(.BHMDidUpdateUserActivityEvent)
    }
    open func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        var item = BeeHive.shared.context?.userActivityItem
        item?.userActivityType = userActivityType
        item?.userActivityError = error
        BHModuleManager.shared.triggerEvent(.BHMDidFailToContinueUserActivityEvent)
    }
    open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        BeeHive.shared.context?.userActivityItem.userActivity = userActivity
        BeeHive.shared.context?.userActivityItem.restorationHandler = restorationHandler
        BHModuleManager.shared.triggerEvent(.BHMContinueUserActivityEvent)
        return true
    }
    
    open func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        BeeHive.shared.context?.userActivityItem.userActivityType = userActivityType
        BHModuleManager.shared.triggerEvent(.BHMWillContinueUserActivityEvent)
        return true
    }
    
    open func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        BeeHive.shared.context?.watchItem = BHWatchItem(userInfo: userInfo, replyHandler: reply)
        BHModuleManager.shared.triggerEvent(.BHMHandleWatchKitExtensionRequestEvent)
    }
    
    open func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var notItem = BeeHive.shared.context?.notificationsItem
        notItem?.notification = notification
        notItem?.notificationPresentationOptionsHandler = completionHandler
        notItem?.center = center
        BHModuleManager.shared.triggerEvent(.BHMWillPresentNotificationEvent)
    }
    
    open func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        var notItem = BeeHive.shared.context?.notificationsItem
        notItem?.notificationResponse = response
        notItem?.notificationCompletionHandler = completionHandler
        notItem?.center = center
        BHModuleManager.shared.triggerEvent(.BHMDidReceiveNotificationResponseEvent)
    }
}

extension BHAppDelegate: UNUserNotificationCenterDelegate { }

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
