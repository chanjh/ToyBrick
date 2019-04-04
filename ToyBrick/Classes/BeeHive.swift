//
//  BeeHive.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

public class BeeHive {
    public static let shared: BeeHive = BeeHive()
    public var enableException: Bool = false
    public var context: BHContext? {
        didSet {
            loadStaticServices()
            loadStaticModules()
        }
    }
    public class func registerDynamicModule(_ module: AnyClass) {
        BHModuleManager.shared.registerDynamicModule(module)
    }

    public func register<Service>(_ serviceType: Service.Type,
                                  name: String? = nil,
                                  singleton: Bool = false,
                                  factory: @escaping () -> Service?) {
        BHSeriveManager.shared.register(serviceType, name: name, singleton: singleton, factory: factory)
    }

    public func getSingleton<Service>(_ serviceType: Service.Type,
                               name: String? = nil) -> Service? {
        return BHSeriveManager.shared.getSingleton(serviceType, name: name)
    }

    public func create<Service>(_ serviceType: Service.Type,
                                name: String? = nil) -> Service? {
        return BHSeriveManager.shared.create(serviceType, name: name)
    }
}

/// Private
extension BeeHive {
    func loadStaticServices() {
//        BHSeriveManager.shared.enableException = enableException
//        BHSeriveManager.shared.registerLocalServices()
    }
    func loadStaticModules() {
        BHModuleManager.shared.loadLocalModules()
        BHModuleManager.shared.registedAllModules()
    }
}
