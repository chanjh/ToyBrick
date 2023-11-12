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
    public var context: ModuleContext
    
    public required init(_ context: ModuleContext) {
        self.context = context
    }

    public func modSetUp(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modInit(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modSplash(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modQuickAction(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modTearDown(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modWillResignActive(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidEnterBackground(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modWillEnterForeground(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidBecomActive(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modWillTerminate(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modUnmount(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modOpebURL(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidReceiveMemoryWaring(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidFailToRegisterForRemoteNotifications(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidRegisterForRemoteNotifications(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidReceiveRemoteNotification(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidReceiveLocalNotification(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modWillPresentNotification(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidReceiveNotificationResponse(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modWillContinueUserActivity(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modContinueUserActivity(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidFailToContinueUserActivity(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidUpdateContinueUserActivity(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modHandleWatchKitExtensionRequest(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    public func modDidCustomEvent(_ context: ModuleContext, params: [String: Any]?) {
        print("Function: \(#function), line: \(#line) params: \(params ?? [:])")
//        context.tbContext.
    }

    public func moduleFunc() {
        print("Module Func")
    }
}
