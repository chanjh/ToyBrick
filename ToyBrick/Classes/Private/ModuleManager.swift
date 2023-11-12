//
//  ModuleManager.swift
//  ToyBrick
//
//  Created by 陈嘉豪 on 2019/4/5.
//

import Foundation

open class ModuleManager {
    public static let shared = ModuleManager()
    var moduleInfo: [[ModuleKey: ModuleEntry]] = []
    var modules: [ModuleEntry] = []
    var moduleInstances: [ModuleKey: TBModuleProtocol] = [:]
    
    func register(_ entry: ModuleEntry) {
        var exist = false
        for info in moduleInfo {
            if info[entry.key] != nil {
                exist = true
                break
            }
        }
        if !exist {
            let newValue = [entry.key: entry]
            moduleInfo.append(newValue)
        }
        modules.append(entry)
        modules.sort { lmd, rmd -> Bool in
            if lmd.level.rawValue != rmd.level.rawValue {
                return lmd.level.rawValue > rmd.level.rawValue
            } else {
                return lmd.prioriry > rmd.prioriry
            }
        }
    }

    public func triggerEvent(_ eventType: ModuleEventType, param: [String: Any]? = nil) {
        modules.forEach { entry in
            triggerEvent(eventType, entry: entry, param: param)
        }
    }
    
    private func triggerEvent(_ eventType: ModuleEventType, entry: ModuleEntry, param: [String: Any]? = nil) {
        let instance: TBModuleProtocol = moduleInstances[entry.key] ?? entry.module.init(ModuleContext())
        triggerEvent(eventType, target: instance, param: param)
    }
}
 
// MARK: - - Handle

extension ModuleManager {
    private func triggerEvent(_ eventType: ModuleEventType, target: TBModuleProtocol, param: [String: Any]? = nil) {
        let context = target.context
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
        case .didCustomEvent: target.modDidCustomEvent(context, params: param)
        default:
            assertionFailure()
//            target.modDidCustomEvent(context)
        }
    }
}
