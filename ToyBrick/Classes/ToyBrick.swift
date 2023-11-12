//
//  ToyBrick.swift
//  ToyBrick
//
//  Created by chenjiahao.gill on 2019/4/2.
//

import Foundation

public class ToyBrick {
    public static let shared: ToyBrick = .init()
    public var enableException: Bool = false
    public var context: TBContext? {
        didSet {
            loadStaticModules()
        }
    }

    public func register(_ entry: ModuleEntry) {
        ModuleManager.shared.register(entry)
    }

    /**
     注册服务
     - serviceType: Protocol/class/struct
     - name: a key that enable you can register the same Service type
     - singleton:
     - factory: create function
     */
    public func register<Service>(_ serviceType: Service.Type,
                                  name: String? = nil,
                                  singleton: Bool = false,
                                  factory: @escaping () -> Service?)
    {
        TBSeriveManager.shared.register(serviceType, name: name, singleton: singleton, factory: factory)
    }
    
    /**
     创建服务
     - serviceType: Protocol/class/struct
     - name: a key that enable you can register the same Service type
     */
    public func create<Service>(_ serviceType: Service.Type,
                                name: String? = nil) -> Service?
    {
        return TBSeriveManager.shared.create(serviceType, name: name)
    }
}

/// Private
private extension ToyBrick {
    func loadStaticModules() {
//        TBModuleManager.shared.loadLocalModules()
//        TBModuleManager.shared.registedAllModules()
    }
}
