//
//  ModuleManager.swift
//  ToyBrick
//
//  Created by 陈嘉豪 on 2019/4/5.
//

import Foundation

class ModuleManager {
    
    static let shared = ModuleManager()
    /// 通过 key（name + Module.Type）找到 Entry
    var moduleInfo: [[ModuleKey: ModuleEntry]] = []
    /// 按照优先级排序后的 Module
    var modules: [ModuleEntry] = []
    /// 保存实例化后的 Module
    var moduleInstances: [ModuleKey: TBModuleProtocol] = [:]

    /**
     注册模块
     - module: 实现 TBModuleProtocol 协议的类型
     - level: 等级，越大越优先
     - prioriry: 优先级，越大越优先
    */
    func register<Module>(_ module: Module.Type,
                          level: ModuleLevel,
                          prioriry: ModulePrioriry) {
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

    /**
     调用已经注册对应 eventType 的 Module，并带上参数
     - eventType: Module 事件类型
     - param: 参数
     */
    // TODO: anyhashable
    func triggerEvent(_ eventType: ModuleEventType, param: [String: Any]? = nil) {
        modules.forEach { (entry) in
            triggerEvent(eventType, entry: entry, param: param)
        }
    }
    /**
     调用某个 Module 的 event，并带上参数
     - eventType: Module 事件类型
     - entry: 带初始化的类型
     - param: 参数
     */
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
