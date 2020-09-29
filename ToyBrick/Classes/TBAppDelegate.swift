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
        ModuleManager.shared.triggerEvent(.setupEvent)
        ModuleManager.shared.triggerEvent(.initEvent)
        DispatchQueue.main.async {
            ModuleManager.shared.triggerEvent(.splashEvent)
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
        ModuleManager.shared.triggerEvent(.quickActionEvent)
    }
    
    open func applicationWillResignActive(_ application: UIApplication) {
        ModuleManager.shared.triggerEvent(.willResignActiveEvent)
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        ModuleManager.shared.triggerEvent(.didEnterBackgroundEvent)
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        ModuleManager.shared.triggerEvent(.willEnterForegroundEvent)
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        ModuleManager.shared.triggerEvent(.didBecomeActiveEvent)
    }
    
    open func applicationWillTerminate(_ application: UIApplication) {
        ModuleManager.shared.triggerEvent(.willTerminateEvent)
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let item = TBOpenURLItem(openURL: url, options: options)
        ToyBrick.shared.context?.openURLItem = item
        ModuleManager.shared.triggerEvent(.openURLEvent)
        return true
    }

    open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        ModuleManager.shared.triggerEvent(.didReceiveMemoryWarningEvent)
    }

    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        TBContext.shared.notificationsItem.error = error
        ModuleManager.shared.triggerEvent(.didFailToRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        ToyBrick.shared.context?.notificationsItem.deviceToken = deviceToken
        ModuleManager.shared.triggerEvent(.didRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        var notItem = ToyBrick.shared.context?.notificationsItem
        notItem?.userInfo = userInfo
        notItem?.notificationResultHander = completionHandler
        ModuleManager.shared.triggerEvent(.didRegisterForRemoteNotificationsEvent)
    }
    
    open func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        ToyBrick.shared.context?.userActivityItem.userActivity = userActivity
        ModuleManager.shared.triggerEvent(.didUpdateUserActivityEvent)
    }
    open func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        var item = ToyBrick.shared.context?.userActivityItem
        item?.userActivityType = userActivityType
        item?.userActivityError = error
        ModuleManager.shared.triggerEvent(.didFailToContinueUserActivityEvent)
    }
    open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        ToyBrick.shared.context?.userActivityItem.userActivity = userActivity
        ToyBrick.shared.context?.userActivityItem.restorationHandler = restorationHandler
        ModuleManager.shared.triggerEvent(.continueUserActivityEvent)
        return true
    }
    
    open func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        ToyBrick.shared.context?.userActivityItem.userActivityType = userActivityType
        ModuleManager.shared.triggerEvent(.willContinueUserActivityEvent)
        return true
    }
    
    open func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        ToyBrick.shared.context?.watchItem = TBWatchItem(userInfo: userInfo, replyHandler: reply)
        ModuleManager.shared.triggerEvent(.handleWatchKitExtensionRequestEvent)
    }
    
    open func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var notItem = ToyBrick.shared.context?.notificationsItem
        notItem?.notification = notification
        notItem?.notificationPresentationOptionsHandler = completionHandler
        notItem?.center = center
        ModuleManager.shared.triggerEvent(.willPresentNotificationEvent)
    }
    
    open func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        var notItem = ToyBrick.shared.context?.notificationsItem
        notItem?.notificationResponse = response
        notItem?.notificationCompletionHandler = completionHandler
        notItem?.center = center
        ModuleManager.shared.triggerEvent(.didReceiveNotificationResponseEvent)
    }
}

extension TBAppDelegate: UNUserNotificationCenterDelegate { }

typealias TBShortcutCompletionHandler = (Bool) -> Void
public struct TBShortcutItem {
    var shortcutItem: UIApplicationShortcutItem
    var scompletionHandler: TBShortcutCompletionHandler
}

public struct TBOpenURLItem {
	public var openURL: URL
	public var options: [UIApplication.OpenURLOptionsKey : Any]
}

typealias TBNotificationResultHandler = (UIBackgroundFetchResult) -> Void
typealias TBNotificationPresentationOptionsHandler = (UNNotificationPresentationOptions) -> Void
typealias TBNotificationCompletionHandler = () -> Void
public struct TBNotificationsItem {
	public var error: Error?
	public var deviceToken: Data?
	public var userInfo: [AnyHashable : Any]?
	var notificationResultHander: TBNotificationResultHandler?
	public var notification: UNNotification?
	var notificationPresentationOptionsHandler: TBNotificationPresentationOptionsHandler?
	public var center: UNUserNotificationCenter?
	public var notificationResponse: UNNotificationResponse?
	var notificationCompletionHandler: TBNotificationCompletionHandler?
}

typealias TBUserActivityRestorationHandler = ([UIUserActivityRestoring]?) -> Void
public struct TBUserActivityItem {
	public var userActivity: NSUserActivity?
	public var userActivityType: String?
    var userActivityError: Error?
    var restorationHandler: TBUserActivityRestorationHandler?
}

typealias TBWatchReplyHandler = ([AnyHashable : Any]?) -> Void
public struct TBWatchItem {
    var userInfo: [AnyHashable: Any]?
    var replyHandler: TBWatchReplyHandler?
}
