//
//  BHModuleProtocol.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

/// NSObjectProtocol 太 OC 了，有没有 Swift 一点的做法？
protocol BHModuleProtocol: NSObjectProtocol {
    func basicModuleLevel() -> BHModuleLevel
    var modulePrioriry: Int { get }
    var async: Bool { get }

    init(_ context: BHContext)
    
    func modSetUp(_ context: BHContext)
    func modInit(_ context: BHContext)
    func modSplash(_ context: BHContext)
    func modQuickAction(_ context: BHContext)
    func modTearDown(_ context: BHContext)
    func modWillResignActive(_ context: BHContext)
    func modDidEnterBackground(_ context: BHContext)
    func modWillEnterForeground(_ context: BHContext)
    func modDidBecomActive(_ context: BHContext)
    func modWillTerminate(_ context: BHContext)
    func modUnmount(_ context: BHContext)
    func modOpebURL(_ context: BHContext)
    func modDidReceiveMemoryWaring(_ context: BHContext)
    func modDidFailToRegisterForRemoteNotifications(_ context: BHContext)
    func modDidRegisterForRemoteNotifications(_ context: BHContext)
    func modDidReceiveRemoteNotification(_ context: BHContext)
    func modDidReceiveLocalNotification(_ context: BHContext)
    func modWillPresentNotification(_ context: BHContext)
    func modDidReceiveNotificationResponse(_ context: BHContext)
    func modWillContinueUserActivity(_ context: BHContext)
    func modContinueUserActivity(_ context: BHContext)
    func modDidFailToContinueUserActivity(_ context: BHContext)
    func modDidUpdateContinueUserActivity(_ context: BHContext)
    func modHandleWatchKitExtensionRequest(_ context: BHContext)
    func modDidCustomEvent(_ context: BHContext)
}

extension BHModuleProtocol {
    func basicModuleLevel() -> BHModuleLevel { return BHModuleLevel.BHModuleNormal }
    var modulePrioriry: Int { return 1000 }
    var async: Bool { return true }
    func modSetUp(_ context: BHContext) { }
    func modInit(_ context: BHContext) { }
    func modSplash(_ context: BHContext) { }
    func modQuickAction(_ context: BHContext) { }
    func modTearDown(_ context: BHContext) { }
    func modWillResignActive(_ context: BHContext) { }
    func modDidEnterBackground(_ context: BHContext) { }
    func modWillEnterForeground(_ context: BHContext) { }
    func modDidBecomActive(_ context: BHContext) { }
    func modWillTerminate(_ context: BHContext) { }
    func modUnmount(_ context: BHContext) { }
    func modOpebURL(_ context: BHContext) { }
    func modDidReceiveMemoryWaring(_ context: BHContext) { }
    func modDidFailToRegisterForRemoteNotifications(_ context: BHContext) { }
    func modDidRegisterForRemoteNotifications(_ context: BHContext) { }
    func modDidReceiveRemoteNotification(_ context: BHContext) { }
    func modDidReceiveLocalNotification(_ context: BHContext) { }
    func modWillPresentNotification(_ context: BHContext) { }
    func modDidReceiveNotificationResponse(_ context: BHContext) { }
    func modWillContinueUserActivity(_ context: BHContext) { }
    func modContinueUserActivity(_ context: BHContext) { }
    func modDidFailToContinueUserActivity(_ context: BHContext) { }
    func modDidUpdateContinueUserActivity(_ context: BHContext) { }
    func modHandleWatchKitExtensionRequest(_ context: BHContext) { }
    func modDidCustomEvent(_ context: BHContext) { }
}


//@optional
//
////如果不去设置Level默认是Normal
////basicModuleLevel不去实现默认Normal
//- (void)basicModuleLevel;
////越大越优先
//- (NSInteger)modulePriority;
