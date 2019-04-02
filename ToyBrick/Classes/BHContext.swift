//
//  BHContext.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import UIKit

public class BHContext {
    public static let shared: BHContext = BHContext()
    
    public var application: UIApplication?
    public var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    public var moduleName: String?
    public var serviceConfigName: String?

    public var customParam: [AnyHashable: Any]?
    public var customEvent: BHModuleEventType?

    public var touchShortcutItem: BHShortcutItem?
    public var openURLItem: BHOpenURLItem?
    public var notificationsItem: BHNotificationsItem = BHNotificationsItem()
    public var userActivityItem: BHUserActivityItem = BHUserActivityItem()
    public var watchItem: BHWatchItem?
}
