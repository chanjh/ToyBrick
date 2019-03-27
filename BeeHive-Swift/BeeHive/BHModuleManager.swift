//
//  BHModuleManager.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

class BHModuleManager {
    static let shared: BHModuleManager = BHModuleManager()
    
    func registerDynamicModule(_ moduleClass: AnyClass) {
        
    }
    
    func triggerEvent(_ eventType: BHModuleEventType, param: [String: Any]? = nil) {
        
    }
}
