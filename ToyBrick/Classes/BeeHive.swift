//
//  BeeHive.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

class BeeHive {
    static let shared: BeeHive = BeeHive()
    var enableException: Bool = false
    var context: BHContext? {
        didSet {
            loadStaticServices()
            loadStaticModules()
        }
    }
    class func registerDynamicModule(_ module: AnyClass) {
        BHModuleManager.shared.registerDynamicModule(module)
    }
}

/// Private
extension BeeHive {
    private func loadStaticServices() {
        
    }
    private func loadStaticModules() {
        BHModuleManager.shared.loadLocalModules()
        BHModuleManager.shared.registedAllModules()
    }
}
