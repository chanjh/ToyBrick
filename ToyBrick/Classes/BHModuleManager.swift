//
//  BHModuleManager.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

class BHModuleManager {
    
    fileprivate let kModuleArrayKey               = "moduleClasses"
    fileprivate let kModuleInfoNameKey            = "moduleClass"
    fileprivate let kModuleInfoLevelKey           = "moduleLevel"
    fileprivate let kModuleInfoPriorityKey        = "modulePriority"
    fileprivate let kModuleInfoHasInstantiatedKey = "moduleHasInstantiated"
    
    static let shared: BHModuleManager = BHModuleManager()
    fileprivate var BHModuleInfos: [[String: Any]] = []
    fileprivate var BHModules: [BHModuleProtocol] = []
    fileprivate var BHSelectorByEvent: [Int: String] = [:]//makeSelectorByEvent()
    fileprivate var BHModulesByEvent: [Int: [BHModuleProtocol]] = [:]
    
    func registerDynamicModule(_ moduleClass: AnyClass, shouldTriggerInitEvent: Bool = false) {
        addModule(from: moduleClass, shouldTriggerInitEvent: shouldTriggerInitEvent)
    }
    
    func triggerEvent(_ eventType: BHModuleEventType, param: [String: Any]? = nil) {
        if eventType == .BHMSetupEvent {
            handleModulesSetupEvent()
        } else if eventType == .BHMTearDownEvent {
            for index in (BHModules.count - 1)...0 {
                BHModules[index].modTearDown(BHContext.shared)
            }
        } else {
            BHModules.forEach { (instance) in
                triggerEvent(eventType, target: instance, param: param)
            }
        }
    }
    
    func loadLocalModules() {
        guard let path = Bundle.main.path(forResource: BHContext.shared.moduleName, ofType: "plist"),
            FileManager.default.fileExists(atPath: path) else { return }
        let moduleList = NSDictionary(contentsOfFile: path)
        var moduleInfoByClass: [String: Int] = [:]
        guard let modulesArray = (moduleList?.object(forKey: kModuleArrayKey) as? [[String: Any]]) else { return }
        BHModuleInfos.forEach { (info) in
            if let key = info[kModuleInfoNameKey] as? String {
                moduleInfoByClass[key] = 1
            }
        }
        modulesArray.forEach { (dict) in
            if let key = dict[kModuleInfoNameKey] as? String {
                if moduleInfoByClass[key] == nil {
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
            let hasInstantiated = module[kModuleInfoHasInstantiatedKey] as? Bool ?? false
            let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            let realClassName = (appName?.replacingOccurrences(of: "-", with: "_") ?? "") + "." + classStr
            if let moduleClass = NSClassFromString(realClassName) as? BHModuleProtocol.Type, !hasInstantiated {
                /// TODO: 延迟实例化
                let moduleInstance = moduleClass.init(BHContext.shared)
                tmpArray.append(moduleInstance)
            }
        }
        BHModules.append(contentsOf: tmpArray)
        registerAllSystemEvents()
    }
}

/// MAKR: -- Register
extension BHModuleManager {
    private func addModule(from obj: AnyClass?, shouldTriggerInitEvent: Bool) {
        guard let cla = obj as? BHModuleProtocol.Type else { return }
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
        var moduleInfo: [String: Any] = [:]
        let moduleInstance = cla.init(BHContext.shared)
        let levelInt = moduleInstance.basicModuleLevel()
        moduleInfo[kModuleInfoLevelKey] = levelInt
        moduleInfo[kModuleInfoNameKey] = moduleName
        BHModuleInfos.append(moduleInfo)
        BHModules.append(moduleInstance)
        moduleInfo[kModuleInfoHasInstantiatedKey] = true
        BHModules.sort { (moduleInstance1, moduleInstance2) -> Bool in
            let module1Level = moduleInstance1.basicModuleLevel()
            let module2Level = moduleInstance2.basicModuleLevel()
            if module1Level.rawValue != module2Level.rawValue {
                return module1Level.rawValue > module2Level.rawValue
            } else {
                return moduleInstance1.modulePrioriry < moduleInstance2.modulePrioriry
            }
        }
        registerEventsByModuleInstance(moduleInstance)
//        if shouldTriggerInitEvent {
//            handleModuleEvent(eventType: .BHMSetupEvent, target: moduleInstance, selectorStr: nil, param: nil)
//            handleModulesInitEvent(for: moduleInstance, param: nil)
//            DispatchQueue.main.async { [weak self] in
//                self?.handleModuleEvent(eventType: .BHMSplashEvent, target: moduleInstance, selectorStr: nil, param: nil)
//            }
//        }
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

/// MARK: -- Handle
extension BHModuleManager {
    private func triggerEvent(_ eventType: BHModuleEventType, target: BHModuleProtocol, param: [String: Any]? = nil) {
        let context = BHContext.shared
        switch eventType {
        case .BHMInitEvent: target.modInit(context)
        case .BHMSplashEvent: target.modSplash(context)
        case .BHMWillResignActiveEvent: target.modWillResignActive(context)
        case .BHMDidEnterBackgroundEvent: target.modDidEnterBackground(context)
        case .BHMWillEnterForegroundEvent: target.modWillEnterForeground(context)
        case .BHMDidBecomeActiveEvent: target.modDidBecomActive(context)
        case .BHMWillTerminateEvent: target.modWillTerminate(context)
        case .BHMUnmountEvent: target.modUnmount(context)
        case .BHMQuickActionEvent: target.modQuickAction(context)
        case .BHMOpenURLEvent: target.modOpebURL(context)
        case .BHMDidReceiveMemoryWarningEvent: target.modDidReceiveMemoryWaring(context)
        case .BHMDidFailToRegisterForRemoteNotificationsEvent: target.modDidFailToRegisterForRemoteNotifications(context)
        case .BHMDidRegisterForRemoteNotificationsEvent: target.modDidRegisterForRemoteNotifications(context)
        case .BHMDidReceiveLocalNotificationEvent: target.modDidReceiveLocalNotification(context)
        case .BHMWillPresentNotificationEvent: target.modWillPresentNotification(context)
        case .BHMDidReceiveNotificationResponseEvent: target.modDidReceiveNotificationResponse(context)
        case .BHMWillContinueUserActivityEvent: target.modWillContinueUserActivity(context)
        case .BHMContinueUserActivityEvent: target.modContinueUserActivity(context)
        case .BHMDidUpdateUserActivityEvent: target.modDidUpdateContinueUserActivity(context)
        case .BHMDidFailToContinueUserActivityEvent: target.modDidFailToContinueUserActivity(context)
        case .BHMHandleWatchKitExtensionRequestEvent: target.modHandleWatchKitExtensionRequest(context)
        default:
            assertionFailure()
//            target.modDidCustomEvent(context)
        }
    }
    private func handleModulesSetupEvent() {
        for instance in BHModules {
            let bk: () -> Void = {
                instance.modSetUp(BHContext.shared)
            }
            if instance.async {
                DispatchQueue.main.async {
                    bk()
                }
            } else {
                bk()
            }
        }
    }
}

extension BHModuleManager {
//    private func handleModuleEvent(eventType: BHModuleEventType,
//                                   target: BHModuleProtocol?,
//                                   param: [AnyHashable: Any]?) {
//        switch eventType {
//        case .BHMInitEvent: handleModulesInitEvent(for: nil, param: param)
//        case .BHMTearDownEvent: handleModulesTearDownEvent(for: nil, param: param)
//        default:
//            handleModuleEvent(eventType: eventType,
//                              target: nil,
//                              selectorStr: BHSelectorByEvent[eventType.rawValue],
//                              param: param)
//        }
//
//    }
//    private func handleModulesInitEvent(for target: BHModuleProtocol?, param: [AnyHashable: Any]?) {
//        let context = BHContext.shared
//        let tmpParam = context.customParam
//        let tmpEvent = context.customEvent
//        context.customParam = param
//        context.customEvent = .BHMInitEvent
//        var moduleInstances: [BHModuleProtocol] = []
//        if let instance = target {
//            moduleInstances.append(instance)
//        } else {
//            moduleInstances = BHModulesByEvent[BHModuleEventType.BHMInitEvent.rawValue] ?? []
//        }
//        moduleInstances.forEach { (instance) in
//            BHTimeProfiler.shared.recordEventTime("\(String(describing: instance.superclass)) -- modInit:")
//            if instance.async {
//                DispatchQueue.main.async {
//                    instance.modInit(context)
//                }
//            } else {
//                instance.modInit(context)
//            }
//        }
//        context.customParam = tmpParam
//        context.customEvent = tmpEvent
//    }
//    private func handleModulesTearDownEvent(for target: BHModuleProtocol?, param: [AnyHashable: Any]?) {
//        let context = BHContext.shared
//        let tmpParam = context.customParam
//        let tmpEvent = context.customEvent
//        context.customParam = param
//        context.customEvent = .BHMInitEvent
//        var moduleInstances: [BHModuleProtocol] = []
//        if let instance = target {
//            moduleInstances.append(instance)
//        } else {
//            moduleInstances = BHModulesByEvent[BHModuleEventType.BHMTearDownEvent.rawValue] ?? []
//        }
//        moduleInstances.forEach { (instance) in
//            instance.modTearDown(context)
//        }
//        context.customParam = tmpParam
//        context.customEvent = tmpEvent
//    }
//    private func handleModuleEvent(eventType: BHModuleEventType,
//                                   target: BHModuleProtocol?,
//                                   selectorStr: String?,
//                                   param: [AnyHashable: Any]?) {
//        guard let selectorStr = selectorStr ?? (BHSelectorByEvent[eventType.rawValue]) else { return }
//        let selector = Selector(selectorStr)
//        var moduleInstances: [BHModuleProtocol] = []
//        if let instance = target {
//            moduleInstances.append(instance)
//        } else {
//            moduleInstances = BHModulesByEvent[eventType.rawValue] ?? []
//        }
//        let context = BHContext.shared
//        let tmpParam = context.customParam
//        let tmpEvent = context.customEvent
//        moduleInstances.forEach { (moduleInstance) in
//            let context = BHContext.shared
//            context.customParam = param
//            context.customEvent = eventType
//            moduleInstance.perform(selector, with: context)
//            BHTimeProfiler.shared.recordEventTime("\(String(describing: moduleInstance.superclass)) --- \(selectorStr)")
//        }
//        context.customParam = tmpParam
//        context.customEvent = tmpEvent
//    }
}
