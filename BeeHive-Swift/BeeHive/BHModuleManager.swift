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
    private var BHModuleInfos: [[String: Any]] = []
    private var BHModules: [BHModuleProtocol] = []
    private var BHSelectorByEvent: [Int: String] = makeSelectorByEvent()
    private var BHModulesByEvent: [Int: [BHModuleProtocol]] = [:]
    
    func registerDynamicModule(_ moduleClass: AnyClass, shouldTriggerInitEvent: Bool = false) {
        addModule(from: moduleClass, shouldTriggerInitEvent: shouldTriggerInitEvent)
    }
    
    func triggerEvent(_ eventType: BHModuleEventType, param: [String: Any]? = nil) {
        handleModuleEvent(eventType: eventType, target: nil, param: param)
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
        if shouldTriggerInitEvent {
            handleModuleEvent(eventType: .BHMSetupEvent, target: moduleInstance, selectorStr: nil, param: nil)
            handleModulesInitEvent(for: moduleInstance, param: nil)
            DispatchQueue.main.async { [weak self] in
                self?.handleModuleEvent(eventType: .BHMSplashEvent, target: moduleInstance, selectorStr: nil, param: nil)
            }
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

/// MARK: -- Handle
extension BHModuleManager {
    private func handleModuleEvent(eventType: BHModuleEventType,
                                   target: BHModuleProtocol?,
                                   param: [AnyHashable: Any]?) {
        switch eventType {
        case .BHMInitEvent: handleModulesInitEvent(for: nil, param: param)
        case .BHMTearDownEvent: handleModulesTearDownEvent(for: nil, param: param)
        default:
            handleModuleEvent(eventType: eventType,
                              target: nil,
                              selectorStr: BHSelectorByEvent[eventType.rawValue],
                              param: param)
        }

    }
    private func handleModulesInitEvent(for target: BHModuleProtocol?, param: [AnyHashable: Any]?) {
        let context = BHContext.shared
        let tmpParam = context.customParam
        let tmpEvent = context.customEvent
        context.customParam = param
        context.customEvent = .BHMInitEvent
        var moduleInstances: [BHModuleProtocol] = []
        if let instance = target {
            moduleInstances.append(instance)
        } else {
            moduleInstances = BHModulesByEvent[BHModuleEventType.BHMInitEvent.rawValue] ?? []
        }
        moduleInstances.forEach { (instance) in
            BHTimeProfiler.shared.recordEventTime("\(String(describing: instance.superclass)) -- modInit:")
            if instance.async {
                DispatchQueue.main.async {
                    instance.modInit(context)
                }
            } else {
                instance.modInit(context)
            }
        }
        context.customParam = tmpParam
        context.customEvent = tmpEvent
    }
    private func handleModulesTearDownEvent(for target: BHModuleProtocol?, param: [AnyHashable: Any]?) {
        let context = BHContext.shared
        let tmpParam = context.customParam
        let tmpEvent = context.customEvent
        context.customParam = param
        context.customEvent = .BHMInitEvent
        var moduleInstances: [BHModuleProtocol] = []
        if let instance = target {
            moduleInstances.append(instance)
        } else {
            moduleInstances = BHModulesByEvent[BHModuleEventType.BHMTearDownEvent.rawValue] ?? []
        }
        moduleInstances.forEach { (instance) in
            instance.modTearDown(context)
        }
        context.customParam = tmpParam
        context.customEvent = tmpEvent
    }
    private func handleModuleEvent(eventType: BHModuleEventType,
                                   target: BHModuleProtocol?,
                                   selectorStr: String?,
                                   param: [AnyHashable: Any]?) {
        guard let selectorStr = selectorStr ?? (BHSelectorByEvent[eventType.rawValue]) else { return }
        let selector = Selector(selectorStr)
        var moduleInstances: [BHModuleProtocol] = []
        if let instance = target {
            moduleInstances.append(instance)
        } else {
            moduleInstances = BHModulesByEvent[eventType.rawValue] ?? []
        }
        let context = BHContext.shared
        let tmpParam = context.customParam
        let tmpEvent = context.customEvent
        moduleInstances.forEach { (moduleInstance) in
            let context = BHContext.shared
            context.customParam = param
            context.customEvent = eventType
            moduleInstance.perform(selector, with: context)
            BHTimeProfiler.shared.recordEventTime("\(String(describing: moduleInstance.superclass)) --- \(selectorStr)")
        }
        context.customParam = tmpParam
        context.customEvent = tmpEvent
    }
}

extension BHModuleManager {
    static let kSetupSelector = "modSetUp(_:)"
    static let kInitSelector  = "modInit(_:)"
//    static  NSString *kSplashSeletor = @"modSplash:";
//    static  NSString *kTearDownSelector = @"modTearDown:";
//    static  NSString *kWillResignActiveSelector = @"modWillResignActive:";
//    static  NSString *kDidEnterBackgroundSelector = @"modDidEnterBackground:";
//    static  NSString *kWillEnterForegroundSelector = @"modWillEnterForeground:";
//    static  NSString *kDidBecomeActiveSelector = @"modDidBecomeActive:";
//    static  NSString *kWillTerminateSelector = @"modWillTerminate:";
//    static  NSString *kUnmountEventSelector = @"modUnmount:";
//    static  NSString *kQuickActionSelector = @"modQuickAction:";
//    static  NSString *kOpenURLSelector = @"modOpenURL:";
//    static  NSString *kDidReceiveMemoryWarningSelector = @"modDidReceiveMemoryWaring:";
//    static  NSString *kFailToRegisterForRemoteNotificationsSelector = @"modDidFailToRegisterForRemoteNotifications:";
//    static  NSString *kDidRegisterForRemoteNotificationsSelector = @"modDidRegisterForRemoteNotifications:";
//    static  NSString *kDidReceiveRemoteNotificationsSelector = @"modDidReceiveRemoteNotification:";
//    static  NSString *kDidReceiveLocalNotificationsSelector = @"modDidReceiveLocalNotification:";
//    static  NSString *kWillPresentNotificationSelector = @"modWillPresentNotification:";
//    static  NSString *kDidReceiveNotificationResponseSelector = @"modDidReceiveNotificationResponse:";
//    static  NSString *kWillContinueUserActivitySelector = @"modWillContinueUserActivity:";
//    static  NSString *kContinueUserActivitySelector = @"modContinueUserActivity:";
//    static  NSString *kDidUpdateContinueUserActivitySelector = @"modDidUpdateContinueUserActivity:";
//    static  NSString *kFailToContinueUserActivitySelector = @"modDidFailToContinueUserActivity:";
//    static  NSString *kHandleWatchKitExtensionRequestSelector = @"modHandleWatchKitExtensionRequest:";
//    static  NSString *kAppCustomSelector = @"modDidCustomEvent:";
    static func makeSelectorByEvent() -> [Int: String] {
        let dict = [
            BHModuleEventType.BHMSetupEvent.rawValue: kSetupSelector,
            BHModuleEventType.BHMInitEvent.rawValue: kInitSelector
//            @(BHMTearDownEvent):kTearDownSelector,
//            @(BHMSplashEvent):kSplashSeletor,
//            @(BHMWillResignActiveEvent):kWillResignActiveSelector,
//            @(BHMDidEnterBackgroundEvent):kDidEnterBackgroundSelector,
//            @(BHMWillEnterForegroundEvent):kWillEnterForegroundSelector,
//            @(BHMDidBecomeActiveEvent):kDidBecomeActiveSelector,
//            @(BHMWillTerminateEvent):kWillTerminateSelector,
//            @(BHMUnmountEvent):kUnmountEventSelector,
//            @(BHMOpenURLEvent):kOpenURLSelector,
//            @(BHMDidReceiveMemoryWarningEvent):kDidReceiveMemoryWarningSelector,
//
//            @(BHMDidReceiveRemoteNotificationEvent):kDidReceiveRemoteNotificationsSelector,
//            @(BHMWillPresentNotificationEvent):kWillPresentNotificationSelector,
//            @(BHMDidReceiveNotificationResponseEvent):kDidReceiveNotificationResponseSelector,
//
//            @(BHMDidFailToRegisterForRemoteNotificationsEvent):kFailToRegisterForRemoteNotificationsSelector,
//            @(BHMDidRegisterForRemoteNotificationsEvent):kDidRegisterForRemoteNotificationsSelector,
//
//            @(BHMDidReceiveLocalNotificationEvent):kDidReceiveLocalNotificationsSelector,
//
//            @(BHMWillContinueUserActivityEvent):kWillContinueUserActivitySelector,
//
//            @(BHMContinueUserActivityEvent):kContinueUserActivitySelector,
//
//            @(BHMDidFailToContinueUserActivityEvent):kFailToContinueUserActivitySelector,
//
//            @(BHMDidUpdateUserActivityEvent):kDidUpdateContinueUserActivitySelector,
//
//            @(BHMQuickActionEvent):kQuickActionSelector,
//            @(BHMHandleWatchKitExtensionRequestEvent):kHandleWatchKitExtensionRequestSelector,
//            @(BHMDidCustomEvent):kAppCustomSelector,
        ]
        return dict
    }
}
