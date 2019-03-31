//
//  BHContext.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import UIKit

class BHContext {
    static let shared: BHContext = BHContext()
    
    var application: UIApplication?
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    var moduleName: String?
    var serviceConfigName: String?

    var customParam: [AnyHashable: Any]?
    var customEvent: BHModuleEventType?

    var touchShortcutItem: BHShortcutItem?
    var openURLItem: BHOpenURLItem?
}
