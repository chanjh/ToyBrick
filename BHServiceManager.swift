//
//  BHServiceManager.swift
//  ToyBrick
//
//  Created by chenjiahao.gill on 2019/4/3.
//  

import Foundation

class BHSeriveManager {
    init() { }
    var enableException: Bool = false
    static let shared: BHSeriveManager = BHSeriveManager()
    let lock = NSRecursiveLock()
    var allServicesDict: [String: String] = [:]

    func registerLocalServices() {
        guard let plist = Bundle.main.path(forResource: BHContext.shared.serviceConfigName, ofType: "plist") else { return }
        let serviceList = NSArray(contentsOfFile: plist)
        lock.lock()
        serviceList?.forEach({ (objc) in
            if let dict = objc as? [String: String],
                let key = dict["service"], key.count > 0,
                let implClass = dict["impl"], implClass.count > 0 {
                allServicesDict[key] = implClass
            }

        })
        lock.unlock()
    }

    func register(_ service: BHServiceProtocol, impl: AnyClass) {

    }

//    func create(service: BHServiceProtocol, name: String?, shouldCache: Bool = true) -> BHServiceProtocol? {
////        var serviceName: NSString = NSStringFromProtocol(service as! Protocol)
//        if name == nil {
//            name =
//        }
//
//
//
//        return nil
//    }
}
