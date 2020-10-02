//
//  ModuleManager.swift
//  ToyBrick
//
//  Created by 陈嘉豪 on 2019/4/5.
//

import Foundation

open class ModuleManager {
    
    static public let shared = ModuleManager()
    var moduleInfo: [[ModuleKey: ModuleEntry]] = []
    var modules: [ModuleEntry] = []
    var moduleInstances: [ModuleKey: TBModuleProtocol] = [:]
    
    func register<Module>(_ module: Module.Type,
                          level: ModuleLevel,
                          prioriry: Int) {
        if !(module is TBModuleProtocol.Type) {
            assertionFailure()
            return
        }
        let key = ModuleKey(module: module)
        let entry = ModuleEntry(module: module, key: key, level: level, prioriry: prioriry)
        var exist = false
        for var info in moduleInfo {
            if info[key] != nil {
                exist = true
                break
            }
        }
        if !exist {
            let newValue = [key: entry]
            moduleInfo.append(newValue)
        }
        modules.append(entry)
        modules.sort { (lmd, rmd) -> Bool in
            if lmd.level.rawValue != rmd.level.rawValue {
                return lmd.level.rawValue > rmd.level.rawValue
            } else {
                return lmd.prioriry > rmd.prioriry
            }
        }
    }

	public func triggerEvent(_ eventType: ModuleEventType, param: [String: Any]? = nil) {
        modules.forEach { (entry) in
            triggerEvent(eventType, entry: entry, param: param)
        }
    }
    
    private func triggerEvent(_ eventType: ModuleEventType, entry: ModuleEntry, param: [String: Any]? = nil) {
        guard let module = entry.module as? TBModuleProtocol.Type else {
            assertionFailure()
            return
        }
        let key = ModuleKey(module: entry.module)
        let instance: TBModuleProtocol = moduleInstances[key] ?? module.init(TBContext.shared)
        triggerEvent(eventType, target: instance, param: param)
    }
}

extension ModuleManager {
    struct ModuleKey: Hashable {
        static func == (lhs: ModuleManager.ModuleKey, rhs: ModuleManager.ModuleKey) -> Bool {
            return lhs.module == rhs.module
        }
        public var hashValue: Int {
            return ObjectIdentifier(module).hashValue
        }
        let module: Any.Type
    }
    struct ModuleEntry {
        let module: Any.Type
        let key: ModuleKey
        let level: ModuleLevel
        let prioriry: Int
    }
}

/// MARK: -- Handle
extension ModuleManager {
    private func triggerEvent(_ eventType: ModuleEventType, target: TBModuleProtocol, param: [String: Any]? = nil) {
        let context = TBContext.shared
        switch eventType {
        case .setupEvent: target.modSetUp(context)
        case .initEvent: target.modInit(context)
        case .tearDownEvent: target.modTearDown(context)
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
}
