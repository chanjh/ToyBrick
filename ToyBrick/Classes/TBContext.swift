//
//  TBContext.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import UIKit

open class TBContext {
    public static let shared: TBContext = .init()
    
    open var application: UIApplication?
    open var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    open var modulePath: String?
    
//    open var customParam: [AnyHashable: Any]?
//    open var customEvent: ModuleEventType?

    open var touchShortcutItem: TBShortcutItem?
    open var openURLItem: TBOpenURLItem?
    open var notificationsItem: TBNotificationsItem = .init()
    open var userActivityItem: TBUserActivityItem = .init()
    open var watchItem: TBWatchItem?
}
