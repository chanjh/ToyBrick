//
//  TBModuleManager.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

class TBModuleManager {
    
    fileprivate let kModuleArrayKey               = "moduleClasses"
    fileprivate let kModuleInfoNameKey            = "moduleClass"
    fileprivate let kModuleInfoLevelKey           = "moduleLevel"
    fileprivate let kModuleInfoPriorityKey        = "modulePriority"
    fileprivate let kModuleInfoHasInstantiatedKey = "moduleHasInstantiated"
    
    static let shared: TBModuleManager = TBModuleManager()
    fileprivate var moduleInfos: [[String: Any]] = []
    fileprivate var modules: [TBModuleProtocol] = []
    fileprivate var selectorByEvent: [Int: String] = [:]//makeSelectorByEvent()
    fileprivate var modulesByEvent: [Int: [TBModuleProtocol]] = [:]
    
    func registerDynamicModule(_ moduleClass: AnyClass, shouldTriggerInitEvent: Bool = false) {
        addModule(from: moduleClass, shouldTriggerInitEvent: shouldTriggerInitEvent)
    }
    
    func triggerEvent(_ eventType: ModuleEventType, param: [String: Any]? = nil) {
        if eventType == .setupEvent {
            handleModulesSetupEvent()
        } else if eventType == .tearDownEvent {
            for index in (modules.count - 1)...0 {
                modules[index].modTearDown(TBContext.shared)
            }
        } else {
            modules.forEach { (instance) in
                triggerEvent(eventType, target: instance, param: param)
            }
        }
    }
    
    func loadLocalModules() {
        guard let path = TBContext.shared.modulePath else { return }
        let moduleList = NSDictionary(contentsOfFile: path)
        var moduleInfoByClass: [String: Int] = [:]
        guard let modulesArray = (moduleList?.object(forKey: kModuleArrayKey) as? [[String: Any]]) else { return }
        moduleInfos.forEach { (info) in
            if let key = info[kModuleInfoNameKey] as? String {
                moduleInfoByClass[key] = 1
            }
        }
        modulesArray.forEach { (dict) in
            if let key = dict[kModuleInfoNameKey] as? String {
                if moduleInfoByClass[key] == nil {
                    self.moduleInfos.append(dict)
                }
            }
        }
    }

    func registedAllModules() {
        moduleInfos.sort { (module1, module2) -> Bool in
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
        var tmpArray: [TBModuleProtocol] = []
        moduleInfos.forEach { (module) in
            guard let classStr = module[kModuleInfoNameKey] as? String else { return }
            let hasInstantiated = module[kModuleInfoHasInstantiatedKey] as? Bool ?? false
            let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            let realClassName = (appName?.replacingOccurrences(of: "-", with: "_") ?? "") + "." + classStr
            if let moduleClass = NSClassFromString(realClassName) as? TBModuleProtocol.Type, !hasInstantiated {
                /// TODO: 延迟实例化
                let moduleInstance = moduleClass.init(TBContext.shared)
                tmpArray.append(moduleInstance)
            }
        }
        modules.append(contentsOf: tmpArray)
        registerAllSystemEvents()
    }
}

/// MAKR: -- Register
extension TBModuleManager {
    private func addModule(from obj: AnyClass?, shouldTriggerInitEvent: Bool) {
        guard let cla = obj as? TBModuleProtocol.Type else { return }
        let moduleName = NSStringFromClass(cla)
        var flag = true
        for module in modules {
            if module.isKind(of: cla) {
                flag = false
                break
            }
        }
        if !flag {
            return
        }
        var moduleInfo: [String: Any] = [:]
        let moduleInstance = cla.init(TBContext.shared)
        let levelInt = moduleInstance.basicModuleLevel()
        moduleInfo[kModuleInfoLevelKey] = levelInt
        moduleInfo[kModuleInfoNameKey] = moduleName
        moduleInfos.append(moduleInfo)
        modules.append(moduleInstance)
        moduleInfo[kModuleInfoHasInstantiatedKey] = true
        modules.sort { (moduleInstance1, moduleInstance2) -> Bool in
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
        modules.forEach { (moduleInstance) in
            self.registerEventsByModuleInstance(moduleInstance)
        }
    }
    private func registerEventsByModuleInstance(_ moduleInstance: TBModuleProtocol) {
        let events = selectorByEvent.keys
        events.forEach { (obj) in
            if let type = ModuleEventType(rawValue: obj), let selector = selectorByEvent[obj] {
                self.registerEvent(type, moduleInstance: moduleInstance, selectorStr: selector)
            }
        }
    }
    private func registerEvent(_ eventType: ModuleEventType, moduleInstance: TBModuleProtocol, selectorStr: String) {
        let selector = NSSelectorFromString(selectorStr)
        if !moduleInstance.responds(to: selector) {
            return
        }
        if selectorByEvent[eventType.rawValue] == nil {
            selectorByEvent[eventType.rawValue] = selectorStr
        }
        if modulesByEvent[eventType.rawValue] == nil {
            modulesByEvent[eventType.rawValue] = []
        }
        if var eventModules = modulesByEvent[eventType.rawValue], !eventModules.contains(where: { (obj) -> Bool in return obj === moduleInstance }) {
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
extension TBModuleManager {
    private func triggerEvent(_ eventType: ModuleEventType, target: TBModuleProtocol, param: [String: Any]? = nil) {
        let context = TBContext.shared
        switch eventType {
        case .initEvent: target.modInit(context)
        case .splashEvent: target.modSplash(context)
        case .willResignActiveEvent: target.modWillResignActive(context)
        case .didEnterBackgroundEvent: target.modDidEnterBackground(context)
        case .willEnterForegroundEvent: target.modWillEnterForeground(context)
        case .didBecomeActiveEvent: target.modDidBecomActive(context)
        case .willTerminateEvent: target.modWillTerminate(context)
        case .unmountEvent: target.modUnmount(context)
        case .quickActionEvent: target.modQuickAction(context)
        case .openURLEvent: target.modOpebURL(context)
        case .didReceiveMemoryWarningEvent: target.modDidReceiveMemoryWaring(context)
        case .didFailToRegisterForRemoteNotificationsEvent: target.modDidFailToRegisterForRemoteNotifications(context)
        case .didRegisterForRemoteNotificationsEvent: target.modDidRegisterForRemoteNotifications(context)
        case .didReceiveLocalNotificationEvent: target.modDidReceiveLocalNotification(context)
        case .willPresentNotificationEvent: target.modWillPresentNotification(context)
        case .didReceiveNotificationResponseEvent: target.modDidReceiveNotificationResponse(context)
        case .willContinueUserActivityEvent: target.modWillContinueUserActivity(context)
        case .continueUserActivityEvent: target.modContinueUserActivity(context)
        case .didUpdateUserActivityEvent: target.modDidUpdateContinueUserActivity(context)
        case .didFailToContinueUserActivityEvent: target.modDidFailToContinueUserActivity(context)
        case .handleWatchKitExtensionRequestEvent: target.modHandleWatchKitExtensionRequest(context)
        default:
            assertionFailure()
//            target.modDidCustomEvent(context)
        }
    }
    private func handleModulesSetupEvent() {
        for instance in modules {
            let bk: () -> Void = {
                instance.modSetUp(TBContext.shared)
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
