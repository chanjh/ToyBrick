//
//  BHModuleManager+Define.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/28.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

enum BHModuleEventType: Int {
    case BHMSetupEvent = 0
    case BHMInitEvent
    case BHMTearDownEvent
    case BHMSplashEvent
    case BHMQuickActionEvent
    case BHMWillResignActiveEvent
    case BHMDidEnterBackgroundEvent
    case BHMWillEnterForegroundEvent
    case BHMDidBecomeActiveEvent
    case BHMWillTerminateEvent
    case BHMUnmountEvent
    case BHMOpenURLEvent
    case BHMDidReceiveMemoryWarningEvent
    case BHMDidFailToRegisterForRemoteNotificationsEvent
    case BHMDidRegisterForRemoteNotificationsEvent
    case BHMDidReceiveRemoteNotificationEvent
    case BHMDidReceiveLocalNotificationEvent
    case BHMWillPresentNotificationEvent
    case BHMDidReceiveNotificationResponseEvent
    case BHMWillContinueUserActivityEvent
    case BHMContinueUserActivityEvent
    case BHMDidFailToContinueUserActivityEvent
    case BHMDidUpdateUserActivityEvent
    case BHMHandleWatchKitExtensionRequestEvent
    case BHMDidCustomEvent
}
