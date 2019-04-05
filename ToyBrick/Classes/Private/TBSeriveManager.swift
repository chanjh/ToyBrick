//
//  TBServiceManager.swift
//  ToyBrick
//
//  Created by chenjiahao.gill on 2019/4/3.
//  

import Foundation

internal typealias FunctionType = Any
class TBSeriveManager {
    static let shared = TBSeriveManager()
    private var serviceInfos: [ServiceKey: ServiceEntry] = [:]
    private var serviceInstances: [ServiceKey: Any] = [:]

    func register<Service>(_ serviceType: Service.Type,
                           name: String? = nil,
                           singleton: Bool = false,
                           factory: @escaping () -> Service?) {
        let key = ServiceKey(serviceType: serviceType, name: name)
        let entry = ServiceEntry(serviceType: serviceType, key: key, factory: factory)
        serviceInfos[key] = entry
        if singleton, let instance = factory() {
            serviceInstances[key] = instance
        }
    }

    func getSingleton<Service>(_ serviceType: Service.Type,
                               name: String? = nil) -> Service? {
        let key = ServiceKey(serviceType: serviceType, name: name)
        return serviceInstances[key] as? Service ?? nil
    }

    func create<Service>(_ serviceType: Service.Type,
                         name: String? = nil) -> Service? {
        let key = ServiceKey(serviceType: serviceType, name: name)
        guard let entry = serviceInfos[key] else { return nil }
        guard let factory = entry.factory as? () -> Service? else { return nil }
        return factory()
    }
}

private extension TBSeriveManager {
    struct ServiceEntry {
        let serviceType: Any.Type
        let key: ServiceKey
        let factory: FunctionType
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
