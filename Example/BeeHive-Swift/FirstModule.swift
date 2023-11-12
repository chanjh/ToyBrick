//
//  FirstModule.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/28.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation
import Middle
import ToyBrick

class FirstModule: TBModuleProtocol {
    var context: ModuleContext
    
    required init(_ context: ModuleContext) {
        self.context = context
    }

    func modSetUp(_ context: ModuleContext) {
        ToyBrick.shared.register(FirstServiceProtocol.self) { () -> FirstService? in
            FirstService()
        }
//        Middle.shared.registerModule001()
        print("Function: \(#function), line: \(#line)")
    }

    func modInit(_ context: ModuleContext) {
        print("Function: \(#function), line: \(#line)")
    }

    func modSplash(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modQuickAction(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modTearDown(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modWillResignActive(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modDidEnterBackground(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modWillEnterForeground(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modDidBecomActive(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modWillTerminate(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modUnmount(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modOpebURL(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveMemoryWaring(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modDidFailToRegisterForRemoteNotifications(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modDidRegisterForRemoteNotifications(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveRemoteNotification(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveLocalNotification(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modWillPresentNotification(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modDidReceiveNotificationResponse(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modWillContinueUserActivity(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modContinueUserActivity(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modDidFailToContinueUserActivity(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modDidUpdateContinueUserActivity(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modHandleWatchKitExtensionRequest(_ context: ModuleContext) { print("Function: \(#function), line: \(#line)") }
    func modDidCustomEvent(_ context: ModuleContext, params: [String: Any]?) {
        print("Function: \(#function), line: \(#line) params: \(params ?? [:])")
    }
}
