//
//  TBContext.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import UIKit

open class TBContext {
    public static let shared: TBContext = TBContext()
    
    open var application: UIApplication?
    open var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    open var moduleName: String?
    open var serviceConfigName: String?

    open var customParam: [AnyHashable: Any]?
    open var customEvent: BHModuleEventType?

    open var touchShortcutItem: BHShortcutItem?
    open var openURLItem: BHOpenURLItem?
    open var notificationsItem: BHNotificationsItem = BHNotificationsItem()
    open var userActivityItem: BHUserActivityItem = BHUserActivityItem()
    open var watchItem: BHWatchItem?
}
