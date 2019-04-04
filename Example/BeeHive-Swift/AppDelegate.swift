//
//  AppDelegate.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import UIKit
import ToyBrick

@UIApplicationMain
class AppDelegate: TBAppDelegate {

    var window: UIWindow?
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        TBContext.shared.application = application
        TBContext.shared.launchOptions = launchOptions
        TBContext.shared.moduleName = "ToyBrick.bundle/BeeHive"
        TBContext.shared.serviceConfigName = "ToyBrick.bundle/BHService"
        ToyBrick.shared.enableException = true
        ToyBrick.shared.context = TBContext.shared
        TBTimeProfiler.shared.recordEventTime("BeeHive::super start launch")

        ToyBrick.registerDynamicModule(FirstModule.self)
        ToyBrick.shared.register(FirstServiceProtocol.self) { () -> FirstService? in
            return FirstService()
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

}

