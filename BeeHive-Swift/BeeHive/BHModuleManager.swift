//
//  BHModuleManager.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

fileprivate let kModuleArrayKey               = "moduleClasses"
fileprivate let kModuleInfoNameKey            = "moduleClass"
fileprivate let kModuleInfoLevelKey           = "moduleLevel"
fileprivate let kModuleInfoPriorityKey        = "modulePriority"
fileprivate let kModuleInfoHasInstantiatedKey = "moduleHasInstantiated"

class BHModuleManager {
    static let shared: BHModuleManager = BHModuleManager()
    private var BHModuleInfos: [[String: Any]] = []
    private var BHModules: [BHModuleProtocol] = []
    private var BHSelectorByEvent: [Int: String] = [:]
    
    func registerDynamicModule(_ moduleClass: AnyClass) {
        
    }
    
    func triggerEvent(_ eventType: BHModuleEventType, param: [String: Any]? = nil) {
        
    }
    func loadLocalModules() {
        guard let path = Bundle.main.path(forResource: BHContext.shared.moduleName, ofType: "plist"),
            FileManager.default.fileExists(atPath: path) else { return }
        let moduleList = NSDictionary(contentsOfFile: path)
        var moduleInfoByClass: [Int: Int] = [:]
        guard let modulesArray = (moduleList?.object(forKey: kModuleArrayKey) as? Array<[String: Int]>) else { return }
        BHModuleInfos.forEach { (info) in
            if let key = info[kModuleInfoNameKey] as? Int {
                moduleInfoByClass[key] = 1
            }
        }
        modulesArray.forEach { (dict) in
            if let key = dict[kModuleInfoNameKey] {
                if moduleInfoByClass[key] != nil {
                    self.BHModuleInfos.append(dict)
                }
            }
        }
    }
    func registedAllModules() {
        BHModuleInfos.sort { (module1, module2) -> Bool in
            guard let module1Level = module1[kModuleInfoNameKey]  as? Int, let module2Level = module2[kModuleInfoLevelKey] as? Int else {
                return false
            }
            if module1Level != module2Level {
                return module1Level > module2Level
            } else {
                guard let module1Priority = module1[kModuleInfoPriorityKey] as? Int, let module2Priority = module2[kModuleInfoPriorityKey] as? Int else { return false }
                return module1Priority < module2Priority
            }
        }
        var tmpArray: [BHModuleProtocol] = []
        BHModuleInfos.forEach { (module) in
            guard let classStr = module[kModuleInfoNameKey] as? String else { return }
            let moduleClass: AnyClass? = NSClassFromString(classStr)
            let hasInstantiated = module[kModuleInfoHasInstantiatedKey] as? Bool ?? false
            if moduleClass != nil, let moduleInstance = (moduleClass)?.initialize() as? BHModuleProtocol, !hasInstantiated {
                tmpArray.append(moduleInstance)
            }
        }
        BHModules.append(contentsOf: tmpArray)
        registerAllSystemEvents()
    }
}

/// Private
extension BHModuleManager {
    private func registerAllSystemEvents() {
        BHModules.forEach { (moduleInstance) in
            self.registerEventsByModuleInstance(moduleInstance)
        }
    }
    private func registerEventsByModuleInstance(_ moduleInstance: BHModuleProtocol) {
        let events = BHSelectorByEvent.keys
        events.forEach { (obj) in
            if let type = BHModuleEventType(rawValue: obj), let selector = BHSelectorByEvent[obj] {
                self.registerEvent(type, moduleInstance: moduleInstance, selector: selector)
            }
        }
    }
    private func registerEvent(_ eventType: BHModuleEventType, moduleInstance: BHModuleProtocol, selector: String) {
        
    }
}
