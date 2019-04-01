//
//  FirstModule.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/28.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

class FirstModule: NSObject, BHModuleProtocol {
    required init(_ context: BHContext) { }
    func modSetUp(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modInit(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modSplash(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modQuickAction(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modTearDown(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modWillResignActive(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modDidEnterBackground(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modWillEnterForeground(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modDidBecomActive(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modWillTerminate(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modUnmount(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modOpebURL(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveMemoryWaring(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modDidFailToRegisterForRemoteNotifications(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modDidRegisterForRemoteNotifications(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveRemoteNotification(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveLocalNotification(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modWillPresentNotification(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveNotificationResponse(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modWillContinueUserActivity(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modContinueUserActivity(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modDidFailToContinueUserActivity(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modDidUpdateContinueUserActivity(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modHandleWatchKitExtensionRequest(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
    func modDidCustomEvent(_ context: BHContext) { print("Function: \(#function), line: \(#line)") }
}
