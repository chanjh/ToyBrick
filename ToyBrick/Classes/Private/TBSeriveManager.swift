//
//  TBServiceManager.swift
//  ToyBrick
//
//  Created by chenjiahao.gill on 2019/4/3.
//

import Foundation

typealias FunctionType = Any
class TBSeriveManager {
    static let shared = TBSeriveManager()
    /// 已经注册的对象
    private var serviceInfos: [ServiceKey: ServiceEntry] = [:]
    /// 已经实例化的对象
    private var serviceInstances: [ServiceKey: Any] = [:]
    /**
     注册服务
     - serviceType: Protocol/class/struct
     - name: a key that enable you can register the same Service type
     - singleton:
     - factory: create function
     */
    func register<Service>(_ serviceType: Service.Type,
                           name: String? = nil,
                           singleton: Bool = false,
                           factory: @escaping () -> Service?)
    {
        let key = ServiceKey(serviceType: serviceType, name: name)
        let entry = ServiceEntry(serviceType: serviceType, key: key, factory: factory, singleton: singleton)
        serviceInfos[key] = entry
        if singleton, let instance = factory() {
            serviceInstances[key] = instance
        }
    }

    /**
     创建服务
     - serviceType: Protocol/class/struct
     - name: a key that enable you can register the same Service type
     */
    func create<Service>(_ serviceType: Service.Type,
                         name: String? = nil) -> Service?
    {
        let key = ServiceKey(serviceType: serviceType, name: name)
        guard let entry = serviceInfos[key] else { return nil }
        if entry.singleton, serviceInstances[key] as? Service != nil {
            return serviceInstances[key] as? Service
        } else {
            guard let factory = entry.factory as? () -> Service? else { return nil }
            let service = factory()
            serviceInstances[key] = service
            return service
        }
    }
}

private extension TBSeriveManager {
    struct ServiceEntry {
        let serviceType: Any.Type
        let key: ServiceKey
        let factory: FunctionType
        let singleton: Bool
    }

    struct ServiceKey: Hashable {
        static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
            return lhs.name == rhs.name && lhs.serviceType == rhs.serviceType
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(serviceType).hashValue)
        }

        let serviceType: Any.Type
        let name: String?
    }
}
