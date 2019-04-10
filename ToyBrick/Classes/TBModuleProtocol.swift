//
//  TBModuleProtocol.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

public struct ModuleContext {
    var tbContext: TBContext
    var param: [AnyHashable: Any]?
    public init(tbContext: TBContext = TBContext.shared, param: [AnyHashable: Any]? = nil) {
        self.tbContext = tbContext
        self.param = param
    }
}

public struct ModuleEntry<Module> {
    let module: Module.Type
    let level: ModuleLevel
    let prioriry: Int
    public init(module: Module.Type, level: ModuleLevel = .normal, prioriry: ModulePrioriry = 1000) {
        self.module = module
        self.level = level
        self.prioriry = prioriry
    }
}

public protocol TBModuleProtocol {
    ////越大越优先
    var modulePrioriry: Int { get }
    static func async() -> Bool

    init(_ context: ModuleContext)
    
    func modSetUp(_ context: ModuleContext)
    func modInit(_ context: ModuleContext)
    func modSplash(_ context: ModuleContext)
    func modQuickAction(_ context: ModuleContext)
    func modTearDown(_ context: ModuleContext)
    func modWillResignActive(_ context: ModuleContext)
    func modDidEnterBackground(_ context: ModuleContext)
    func modWillEnterForeground(_ context: ModuleContext)
    func modDidBecomActive(_ context: ModuleContext)
    func modWillTerminate(_ context: ModuleContext)
    func modUnmount(_ context: ModuleContext)
    func modOpebURL(_ context: ModuleContext)
    func modDidReceiveMemoryWaring(_ context: ModuleContext)
    func modDidFailToRegisterForRemoteNotifications(_ context: ModuleContext)
    func modDidRegisterForRemoteNotifications(_ context: ModuleContext)
    func modDidReceiveRemoteNotification(_ context: ModuleContext)
    func modDidReceiveLocalNotification(_ context: ModuleContext)
    func modWillPresentNotification(_ context: ModuleContext)
    func modDidReceiveNotificationResponse(_ context: ModuleContext)
    func modWillContinueUserActivity(_ context: ModuleContext)
    func modContinueUserActivity(_ context: ModuleContext)
    func modDidFailToContinueUserActivity(_ context: ModuleContext)
    func modDidUpdateContinueUserActivity(_ context: ModuleContext)
    func modHandleWatchKitExtensionRequest(_ context: ModuleContext)
    func modDidCustomEvent(_ context: ModuleContext)
}

public extension TBModuleProtocol {
    func basicModuleLevel() -> ModuleLevel { return ModuleLevel.normal }
    var modulePrioriry: Int { return 1000 }
    static func async() -> Bool { return false }
    func modSetUp(_ context: ModuleContext) { }
    func modInit(_ context: ModuleContext) { }
    func modSplash(_ context: ModuleContext) { }
    func modQuickAction(_ context: ModuleContext) { }
    func modTearDown(_ context: ModuleContext) { }
    func modWillResignActive(_ context: ModuleContext) { }
    func modDidEnterBackground(_ context: ModuleContext) { }
    func modWillEnterForeground(_ context: ModuleContext) { }
    func modDidBecomActive(_ context: ModuleContext) { }
    func modWillTerminate(_ context: ModuleContext) { }
    func modUnmount(_ context: ModuleContext) { }
    func modOpebURL(_ context: ModuleContext) { }
    func modDidReceiveMemoryWaring(_ context: ModuleContext) { }
    func modDidFailToRegisterForRemoteNotifications(_ context: ModuleContext) { }
    func modDidRegisterForRemoteNotifications(_ context: ModuleContext) { }
    func modDidReceiveRemoteNotification(_ context: ModuleContext) { }
    func modDidReceiveLocalNotification(_ context: ModuleContext) { }
    func modWillPresentNotification(_ context: ModuleContext) { }
    func modDidReceiveNotificationResponse(_ context: ModuleContext) { }
    func modWillContinueUserActivity(_ context: ModuleContext) { }
    func modContinueUserActivity(_ context: ModuleContext) { }
    func modDidFailToContinueUserActivity(_ context: ModuleContext) { }
    func modDidUpdateContinueUserActivity(_ context: ModuleContext) { }
    func modHandleWatchKitExtensionRequest(_ context: ModuleContext) { }
    func modDidCustomEvent(_ context: ModuleContext) { }
}
