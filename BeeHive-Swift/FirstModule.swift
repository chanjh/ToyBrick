//
//  FirstModule.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/28.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

class FirstModule: NSObject, BHModuleProtocol {
    required init(_ context: BHContext) {

    }
    
    func modInit(_ context: BHContext) {
        print("OJBK!!!!!")
    }
}
