//
//  BHModuleProtocol.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

protocol BHModuleProtocol {
//    var basicModuleLevel { get }
    var modulePrioriry: Int { get }
    var async: Bool { get }
    
    func modSetUp(_ context: BHContext)
    func modInit(_ context: BHContext)
    func modSplash(_ context: BHContext)
    func modQuickAction(_ context: BHContext)
    func modTearDown(_ context: BHContext)
    func modWillResignActive(_ context: BHContext)
    func modDidEnterBackground(_ context: BHContext)
}

extension BHModuleProtocol {
    func modSetUp(_ context: BHContext) { }
    func modInit(_ context: BHContext) { }
    func modSplash(_ context: BHContext) { }
    func modQuickAction(_ context: BHContext) { }
    func modTearDown(_ context: BHContext) { }
    func modWillResignActive(_ context: BHContext) { }
    func modDidEnterBackground(_ context: BHContext) { }
}


//@optional
//
////如果不去设置Level默认是Normal
////basicModuleLevel不去实现默认Normal
//- (void)basicModuleLevel;
////越大越优先
//- (NSInteger)modulePriority;
//
//- (BOOL)async;
//
//- (void)modWillEnterForeground:(BHContext *)context;
//
//- (void)modDidBecomeActive:(BHContext *)context;
//
//- (void)modWillTerminate:(BHContext *)context;
//
//- (void)modUnmount:(BHContext *)context;
//
//- (void)modOpenURL:(BHContext *)context;
//
//- (void)modDidReceiveMemoryWaring:(BHContext *)context;
//
//- (void)modDidFailToRegisterForRemoteNotifications:(BHContext *)context;
//
//- (void)modDidRegisterForRemoteNotifications:(BHContext *)context;
//
//- (void)modDidReceiveRemoteNotification:(BHContext *)context;
//
//- (void)modDidReceiveLocalNotification:(BHContext *)context;
//
//- (void)modWillPresentNotification:(BHContext *)context;
//
//- (void)modDidReceiveNotificationResponse:(BHContext *)context;
//
//- (void)modWillContinueUserActivity:(BHContext *)context;
//
//- (void)modContinueUserActivity:(BHContext *)context;
//
//- (void)modDidFailToContinueUserActivity:(BHContext *)context;
//
//- (void)modDidUpdateContinueUserActivity:(BHContext *)context;
//
//- (void)modHandleWatchKitExtensionRequest:(BHContext *)context;
//
//- (void)modDidCustomEvent:(BHContext *)context;
