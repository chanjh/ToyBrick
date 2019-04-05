//
//  FirstModule.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/28.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation
import ToyBrick

class FirstModule: TBModuleProtocol {
    required init(_ context: TBContext) { }
    func modSetUp(_ context: TBContext) {
        ToyBrick.shared.register(FirstServiceProtocol.self) { () -> FirstService? in
            return FirstService()
        }
        print("Function: \(#function), line: \(#line)")
    }
    func modInit(_ context: TBContext) {
        print("Function: \(#function), line: \(#line)")
    }
    func modSplash(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modQuickAction(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modTearDown(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modWillResignActive(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modDidEnterBackground(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modWillEnterForeground(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modDidBecomActive(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modWillTerminate(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modUnmount(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modOpebURL(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveMemoryWaring(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modDidFailToRegisterForRemoteNotifications(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modDidRegisterForRemoteNotifications(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveRemoteNotification(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveLocalNotification(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modWillPresentNotification(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveNotificationResponse(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modWillContinueUserActivity(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modContinueUserActivity(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modDidFailToContinueUserActivity(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modDidUpdateContinueUserActivity(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modHandleWatchKitExtensionRequest(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
    func modDidCustomEvent(_ context: TBContext) { print("Function: \(#function), line: \(#line)") }
}
