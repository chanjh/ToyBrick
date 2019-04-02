//
//  AppDelegate.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import UIKit
import ToyBrick

@UIApplicationMain
class AppDelegate: BHAppDelegate {

    var window: UIWindow?
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        BHContext.shared.application = application
        BHContext.shared.launchOptions = launchOptions
        BHContext.shared.moduleName = "BeeHive.bundle/BeeHive"
        BHContext.shared.serviceConfigName = "BeeHive.bundle/BHService"
        BeeHive.shared.enableException = true
        BeeHive.shared.context = BHContext.shared
        BHTimeProfiler.shared.recordEventTime("BeeHive::super start launch")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

}

