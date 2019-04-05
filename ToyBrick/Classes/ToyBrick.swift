//
//  ToyBrick.swift
//  ToyBrick
//
//  Created by chenjiahao.gill on 2019/4/2.
//  

import Foundation

public class ToyBrick {
    public static let shared: ToyBrick = ToyBrick()
    public var enableException: Bool = false
    public var context: TBContext? {
        didSet {
            loadStaticModules()
        }
    }
    public func register<Module>(_ module: ModuleEntry<Module>) {
        ModuleManager.shared.register(module)
    }
    @available(*, deprecated, message: "Use ModuleManager")
    public class func registerDynamicModule(_ module: AnyClass) {
//        TBModuleManager.shared.registerDynamicModule(module)
    }

    public func register<Service>(_ serviceType: Service.Type,
                                  name: String? = nil,
                                  singleton: Bool = false,
                                  factory: @escaping () -> Service?) {
        TBSeriveManager.shared.register(serviceType, name: name, singleton: singleton, factory: factory)
    }

    public func getSingleton<Service>(_ serviceType: Service.Type,
                                      name: String? = nil) -> Service? {
        return TBSeriveManager.shared.getSingleton(serviceType, name: name)
    }

    public func create<Service>(_ serviceType: Service.Type,
                                name: String? = nil) -> Service? {
        return TBSeriveManager.shared.create(serviceType, name: name)
    }
}

/// Private
extension ToyBrick {
    fileprivate func loadStaticModules() {
//        TBModuleManager.shared.loadLocalModules()
//        TBModuleManager.shared.registedAllModules()
    }
}
