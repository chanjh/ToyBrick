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
    private var BHModulesByEvent: [Int: [BHModuleProtocol]] = [:]
    
    func registerDynamicModule(_ moduleClass: AnyClass, shouldTriggerInitEvent: Bool = false) {
        addModule(from: moduleClass, shouldTriggerInitEvent: shouldTriggerInitEvent)
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
            let moduleClass: NSObject.Type? = NSClassFromString(classStr) as? NSObject.Type
            let hasInstantiated = module[kModuleInfoHasInstantiatedKey] as? Bool ?? false
            if moduleClass != nil, let moduleInstance = (moduleClass?.init()) as? BHModuleProtocol, !hasInstantiated {
                tmpArray.append(moduleInstance)
            }
        }
        BHModules.append(contentsOf: tmpArray)
        registerAllSystemEvents()
    }
}

/// Private
extension BHModuleManager {
    private func addModule(from obj: AnyClass?, shouldTriggerInitEvent: Bool) {
        guard let cla = obj else { return }
        let moduleName = NSStringFromClass(cla)
        var flag = true
        for module in BHModules {
            if module.isKind(of: cla) {
                flag = false
                break
            }
        }
        if !flag {
            return
        }
        if cla is BHModuleProtocol.Type {
            var moduleInfo: [String: Any] = [:]
            var levelInt = BHModuleLevel.BHModuleNormal
            if cla.instancesRespond(to: NSSelectorFromString("basicModuleLevel")) {
                levelInt = BHModuleLevel.BHModuleBasic
            }
            moduleInfo[kModuleInfoLevelKey] = levelInt
            moduleInfo[kModuleInfoNameKey] = moduleName
            BHModuleInfos.append(moduleInfo)
//            guard let moduleInstance = cla.initialize() as? BHModuleProtocol else { return }
//            BHModules.append(moduleInstance)

//            id<BHModuleProtocol> moduleInstance = [[class alloc] init];
//            [self.BHModules addObject:moduleInstance];
//            [moduleInfo setObject:@(YES) forKey:kModuleInfoHasInstantiatedKey];
//            [self.BHModules sortUsingComparator:^NSComparisonResult(id<BHModuleProtocol> moduleInstance1, id<BHModuleProtocol> moduleInstance2) {
//                NSNumber *module1Level = @(BHModuleNormal);
//                NSNumber *module2Level = @(BHModuleNormal);
//                if ([moduleInstance1 respondsToSelector:@selector(basicModuleLevel)]) {
//                module1Level = @(BHModuleBasic);
//                }
//                if ([moduleInstance2 respondsToSelector:@selector(basicModuleLevel)]) {
//                module2Level = @(BHModuleBasic);
//                }
//                if (module1Level.integerValue != module2Level.integerValue) {
//                return module1Level.integerValue > module2Level.integerValue;
//                } else {
//                NSInteger module1Priority = 0;
//                NSInteger module2Priority = 0;
//                if ([moduleInstance1 respondsToSelector:@selector(modulePriority)]) {
//                module1Priority = [moduleInstance1 modulePriority];
//                }
//                if ([moduleInstance2 respondsToSelector:@selector(modulePriority)]) {
//                module2Priority = [moduleInstance2 modulePriority];
//                }
//                return module1Priority < module2Priority;
//                }
//                }];
//            [self registerEventsByModuleInstance:moduleInstance];
//
//            if (shouldTriggerInitEvent) {
//                [self handleModuleEvent:BHMSetupEvent forTarget:moduleInstance withSeletorStr:nil andCustomParam:nil];
//                [self handleModulesInitEventForTarget:moduleInstance withCustomParam:nil];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self handleModuleEvent:BHMSplashEvent forTarget:moduleInstance withSeletorStr:nil andCustomParam:nil];
//                    });
//            }
//        }

        }
    }

    private func registerAllSystemEvents() {
        BHModules.forEach { (moduleInstance) in
            self.registerEventsByModuleInstance(moduleInstance)
        }
    }
    private func registerEventsByModuleInstance(_ moduleInstance: BHModuleProtocol) {
        let events = BHSelectorByEvent.keys
        events.forEach { (obj) in
            if let type = BHModuleEventType(rawValue: obj), let selector = BHSelectorByEvent[obj] {
                self.registerEvent(type, moduleInstance: moduleInstance, selectorStr: selector)
            }
        }
    }
    private func registerEvent(_ eventType: BHModuleEventType, moduleInstance: BHModuleProtocol, selectorStr: String) {
        let selector = NSSelectorFromString(selectorStr)
        if !moduleInstance.responds(to: selector) {
            return
        }
        if BHSelectorByEvent[eventType.rawValue] == nil {
            BHSelectorByEvent[eventType.rawValue] = selectorStr
        }
        if BHModulesByEvent[eventType.rawValue] == nil {
            BHModulesByEvent[eventType.rawValue] = []
        }
        if var eventModules = BHModulesByEvent[eventType.rawValue], !eventModules.contains(where: { (obj) -> Bool in return obj === moduleInstance }) {
            eventModules.append(moduleInstance)
            eventModules.sort { (moduleInstance1, moduleInstance2) -> Bool in
                let module1Level = moduleInstance1.basicModuleLevel()
                let module2Level = moduleInstance2.basicModuleLevel()
                if module1Level != module2Level {
                    return module1Level.rawValue > module2Level.rawValue
                } else {
                    return moduleInstance1.modulePrioriry < moduleInstance2.modulePrioriry
                }
            }
        }
    }
}
