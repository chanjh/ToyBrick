//
//  TBModuleProtocol.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

/// NSObjectProtocol 太 OC 了，有没有 Swift 一点的做法？
public protocol TBModuleProtocol: NSObjectProtocol {
    func basicModuleLevel() -> ModuleLevel
    ////越大越优先
    var modulePrioriry: Int { get }
    var async: Bool { get }

    init(_ context: TBContext)
    
    func modSetUp(_ context: TBContext)
    func modInit(_ context: TBContext)
    func modSplash(_ context: TBContext)
    func modQuickAction(_ context: TBContext)
    func modTearDown(_ context: TBContext)
    func modWillResignActive(_ context: TBContext)
    func modDidEnterBackground(_ context: TBContext)
    func modWillEnterForeground(_ context: TBContext)
    func modDidBecomActive(_ context: TBContext)
    func modWillTerminate(_ context: TBContext)
    func modUnmount(_ context: TBContext)
    func modOpebURL(_ context: TBContext)
    func modDidReceiveMemoryWaring(_ context: TBContext)
    func modDidFailToRegisterForRemoteNotifications(_ context: TBContext)
    func modDidRegisterForRemoteNotifications(_ context: TBContext)
    func modDidReceiveRemoteNotification(_ context: TBContext)
    func modDidReceiveLocalNotification(_ context: TBContext)
    func modWillPresentNotification(_ context: TBContext)
    func modDidReceiveNotificationResponse(_ context: TBContext)
    func modWillContinueUserActivity(_ context: TBContext)
    func modContinueUserActivity(_ context: TBContext)
    func modDidFailToContinueUserActivity(_ context: TBContext)
    func modDidUpdateContinueUserActivity(_ context: TBContext)
    func modHandleWatchKitExtensionRequest(_ context: TBContext)
    func modDidCustomEvent(_ context: TBContext)
}

public extension TBModuleProtocol {
    func basicModuleLevel() -> ModuleLevel { return ModuleLevel.normal }
    var modulePrioriry: Int { return 1000 }
    var async: Bool { return true }
    func modSetUp(_ context: TBContext) { }
    func modInit(_ context: TBContext) { }
    func modSplash(_ context: TBContext) { }
    func modQuickAction(_ context: TBContext) { }
    func modTearDown(_ context: TBContext) { }
    func modWillResignActive(_ context: TBContext) { }
    func modDidEnterBackground(_ context: TBContext) { }
    func modWillEnterForeground(_ context: TBContext) { }
    func modDidBecomActive(_ context: TBContext) { }
    func modWillTerminate(_ context: TBContext) { }
    func modUnmount(_ context: TBContext) { }
    func modOpebURL(_ context: TBContext) { }
    func modDidReceiveMemoryWaring(_ context: TBContext) { }
    func modDidFailToRegisterForRemoteNotifications(_ context: TBContext) { }
    func modDidRegisterForRemoteNotifications(_ context: TBContext) { }
    func modDidReceiveRemoteNotification(_ context: TBContext) { }
    func modDidReceiveLocalNotification(_ context: TBContext) { }
    func modWillPresentNotification(_ context: TBContext) { }
    func modDidReceiveNotificationResponse(_ context: TBContext) { }
    func modWillContinueUserActivity(_ context: TBContext) { }
    func modContinueUserActivity(_ context: TBContext) { }
    func modDidFailToContinueUserActivity(_ context: TBContext) { }
    func modDidUpdateContinueUserActivity(_ context: TBContext) { }
    func modHandleWatchKitExtensionRequest(_ context: TBContext) { }
    func modDidCustomEvent(_ context: TBContext) { }
}
