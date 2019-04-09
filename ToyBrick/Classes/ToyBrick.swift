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
    /**
     注册模块
     - module: 实现 TBModuleProtocol 协议的类型
     - level: 等级，越大越优先
     - prioriry: 优先级，越大越优先
     */
    public func register<Module>(_ module: ModuleEntry<Module>) {
        ModuleManager.shared.register(module)
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
                                  factory: @escaping () -> Service?) {
        TBSeriveManager.shared.register(serviceType, name: name, singleton: singleton, factory: factory)
    }
    
    /**
     创建服务
     - serviceType: Protocol/class/struct
     - name: a key that enable you can register the same Service type
     */
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
