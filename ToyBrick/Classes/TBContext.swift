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
    open var customEvent: ModuleEventType?

    open var touchShortcutItem: TBShortcutItem?
    open var openURLItem: TBOpenURLItem?
    open var notificationsItem: TBNotificationsItem = TBNotificationsItem()
    open var userActivityItem: TBUserActivityItem = TBUserActivityItem()
    open var watchItem: TBWatchItem?
}
