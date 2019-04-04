//
//  TBModuleManager+Define.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/28.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

public enum ModuleLevel: Int {
    case basic  = 0
    case normal
}

public enum ModuleEventType: Int {
    case setupEvent = 0
    case initEvent
    case tearDownEvent
    case splashEvent
    case quickActionEvent
    case willResignActiveEvent
    case didEnterBackgroundEvent
    case willEnterForegroundEvent
    case didBecomeActiveEvent
    case willTerminateEvent
    case unmountEvent
    case openURLEvent
    case didReceiveMemoryWarningEvent
    case didFailToRegisterForRemoteNotificationsEvent
    case didRegisterForRemoteNotificationsEvent
    case didReceiveRemoteNotificationEvent
    case didReceiveLocalNotificationEvent
    case willPresentNotificationEvent
    case didReceiveNotificationResponseEvent
    case willContinueUserActivityEvent
    case continueUserActivityEvent
    case didFailToContinueUserActivityEvent
    case didUpdateUserActivityEvent
    case handleWatchKitExtensionRequestEvent
    case didCustomEvent
}
