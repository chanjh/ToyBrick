//
//  BHServiceProtocol.swift
//  ToyBrick
//
//  Created by chenjiahao.gill on 2019/4/3.
//  

import Foundation

protocol BHServiceProtocol {
    var singleton: Bool { get }
    static var shared: AnyObject? { get }
}

extension BHServiceProtocol {
    var singleton: Bool { return false }
    static var shared: AnyObject? { return nil }
}
