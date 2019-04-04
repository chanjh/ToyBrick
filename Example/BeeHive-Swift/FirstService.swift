//
//  FirstService.swift
//  BeeHive-Swift
//
//  Created by chenjiahao.gill on 2019/4/4.
//  Copyright © 2019 Gill Chan. All rights reserved.

import Foundation

protocol FirstServiceProtocol {
    func testFunc()
}

class FirstService: FirstServiceProtocol {
    func testFunc() {
        print("OJBK")
    }
}
