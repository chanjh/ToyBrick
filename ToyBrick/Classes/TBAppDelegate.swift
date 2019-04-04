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
        TBModuleManager.shared.triggerEvent(.setupEvent)
        TBModuleManager.shared.triggerEvent(.initEvent)
        DispatchQueue.main.async {
            TBModuleManager.shared.triggerEvent(.splashEvent)
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
        let item = TBShortcutItem(shortcutItem: shortcutItem, scompletionHandler: completionHandler)
        ToyBrick.shared.context?.touchShortcutItem = item
        TBModuleManager.shared.triggerEvent(.quickActionEvent)
    }
    
    open func applicationWillResignActive(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.willResignActiveEvent)
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.didEnterBackgroundEvent)
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.willEnterForegroundEvent)
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.didBecomeActiveEvent)
    }
    
    open func applicationWillTerminate(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.willTerminateEvent)
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let item = TBOpenURLItem(openURL: url, options: options)
        ToyBrick.shared.context?.openURLItem = item
        TBModuleManager.shared.triggerEvent(.openURLEvent)
        return true
    }

    open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        TBModuleManager.shared.triggerEvent(.didReceiveMemoryWarningEvent)
    }

    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        TBContext.shared.notificationsItem.error = error
        TBModuleManager.shared.triggerEvent(.didFailToRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        ToyBrick.shared.context?.notificationsItem.deviceToken = deviceToken
        TBModuleManager.shared.triggerEvent(.didRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        var notItem = ToyBrick.shared.context?.notificationsItem
        notItem?.userInfo = userInfo
        notItem?.notificationResultHander = completionHandler
        TBModuleManager.shared.triggerEvent(.didRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        ToyBrick.shared.context?.userActivityItem.userActivity = userActivity
        TBModuleManager.shared.triggerEvent(.didUpdateUserActivityEvent)
    }
    open func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        var item = ToyBrick.shared.context?.userActivityItem
        item?.userActivityType = userActivityType
        item?.userActivityError = error
        TBModuleManager.shared.triggerEvent(.didFailToContinueUserActivityEvent)
    }
    open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        ToyBrick.shared.context?.userActivityItem.userActivity = userActivity
        ToyBrick.shared.context?.userActivityItem.restorationHandler = restorationHandler
        TBModuleManager.shared.triggerEvent(.continueUserActivityEvent)
        return true
    }
    
    open func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        ToyBrick.shared.context?.userActivityItem.userActivityType = userActivityType
        TBModuleManager.shared.triggerEvent(.willContinueUserActivityEvent)
        return true
    }
    
    open func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        ToyBrick.shared.context?.watchItem = TBWatchItem(userInfo: userInfo, replyHandler: reply)
        TBModuleManager.shared.triggerEvent(.handleWatchKitExtensionRequestEvent)
    }
    
    open func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var notItem = ToyBrick.shared.context?.notificationsItem
        notItem?.notification = notification
        notItem?.notificationPresentationOptionsHandler = completionHandler
        notItem?.center = center
        TBModuleManager.shared.triggerEvent(.willPresentNotificationEvent)
    }
    
    open func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        var notItem = ToyBrick.shared.context?.notificationsItem
        notItem?.notificationResponse = response
        notItem?.notificationCompletionHandler = completionHandler
        notItem?.center = center
        TBModuleManager.shared.triggerEvent(.didReceiveNotificationResponseEvent)
    }
}

extension TBAppDelegate: UNUserNotificationCenterDelegate { }

typealias TBShortcutCompletionHandler = (Bool) -> Void
public struct TBShortcutItem {
    var shortcutItem: UIApplicationShortcutItem
    var scompletionHandler: TBShortcutCompletionHandler
}

public struct TBOpenURLItem {
    var openURL: URL
    var options: [UIApplication.OpenURLOptionsKey : Any]
}

typealias TBNotificationResultHandler = (UIBackgroundFetchResult) -> Void
typealias TBNotificationPresentationOptionsHandler = (UNNotificationPresentationOptions) -> Void
typealias TBNotificationCompletionHandler = () -> Void
public struct TBNotificationsItem {
    var error: Error?
    var deviceToken: Data?
    var userInfo: [AnyHashable : Any]?
    var notificationResultHander: TBNotificationResultHandler?
    var notification: UNNotification?
    var notificationPresentationOptionsHandler: TBNotificationPresentationOptionsHandler?
    var center: UNUserNotificationCenter?
    var notificationResponse: UNNotificationResponse?
    var notificationCompletionHandler: TBNotificationCompletionHandler?
}

typealias TBUserActivityRestorationHandler = ([UIUserActivityRestoring]?) -> Void
public struct TBUserActivityItem {
    var userActivity: NSUserActivity?
    var userActivityType: String?
    var userActivityError: Error?
    var restorationHandler: TBUserActivityRestorationHandler?
}

typealias TBWatchReplyHandler = ([AnyHashable : Any]?) -> Void
public struct TBWatchItem {
    var userInfo: [AnyHashable: Any]?
    var replyHandler: TBWatchReplyHandler?
}
