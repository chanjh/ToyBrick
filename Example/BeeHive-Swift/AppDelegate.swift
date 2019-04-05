//
//  AppDelegate.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import UIKit
import ToyBrick
import Module001

@UIApplicationMain
class AppDelegate: TBAppDelegate {

    var window: UIWindow?
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        TBContext.shared.application = application
        TBContext.shared.launchOptions = launchOptions
        TBContext.shared.modulePath = Bundle.init(for: AppDelegate.self).path(forResource: "ToyBrick.bundle/BeeHive", ofType: "plist")
        ToyBrick.shared.enableException = true
        ToyBrick.shared.context = TBContext.shared
        makeModule()
        TBTimeProfiler.shared.recordEventTime("ToyBrick::super start launch")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func makeModule() {
        ToyBrick.shared.register(ModuleEntry(module: FirstModule.self))
        ToyBrick.shared.register(ModuleEntry(module: Module001.self))
    }
}

