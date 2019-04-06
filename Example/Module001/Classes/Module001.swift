//
//  Module001.swift
//  Module001
//
//  Created by 陈嘉豪 on 2019/4/5.
//

import Foundation
import ToyBrick

public protocol Module001Protocol {
    func moduleFunc()
}

public class Module001: NSObject, TBModuleProtocol, Module001Protocol {
    public required init(_ context: TBContext) { }
    public func modSetUp(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modInit(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modSplash(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modQuickAction(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modTearDown(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modWillResignActive(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidEnterBackground(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modWillEnterForeground(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidBecomActive(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modWillTerminate(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modUnmount(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modOpebURL(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidReceiveMemoryWaring(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidFailToRegisterForRemoteNotifications(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidRegisterForRemoteNotifications(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidReceiveRemoteNotification(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidReceiveLocalNotification(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modWillPresentNotification(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidReceiveNotificationResponse(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modWillContinueUserActivity(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modContinueUserActivity(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidFailToContinueUserActivity(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidUpdateContinueUserActivity(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modHandleWatchKitExtensionRequest(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidCustomEvent(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    public func moduleFunc() {
        print("Module Func")
    }
}
