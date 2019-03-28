//
//  BHModuleManager.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Foundation

class BHModuleManager {
    static let shared: BHModuleManager = BHModuleManager()
    
    func registerDynamicModule(_ moduleClass: AnyClass) {
        
    }
    
    func triggerEvent(_ eventType: BHModuleEventType, param: [String: Any]? = nil) {
        
    }
    func loadLocalModules() {
        guard let path = Bundle.main.path(forResource: BHContext.shared.moduleName, ofType: "plist"),
            FileManager.default.fileExists(atPath: path) else { return }
        let moduleList = NSDictionary(contentsOfFile: path)
        
        
        
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:[BHContext shareInstance].moduleConfigName ofType:@"plist"];
//        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
//            return;
//        }
//
//        NSDictionary *moduleList = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//
//        NSArray<NSDictionary *> *modulesArray = [moduleList objectForKey:kModuleArrayKey];
//        NSMutableDictionary<NSString *, NSNumber *> *moduleInfoByClass = @{}.mutableCopy;
//        [self.BHModuleInfos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [moduleInfoByClass setObject:@1 forKey:[obj objectForKey:kModuleInfoNameKey]];
//            }];
//        [modulesArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (!moduleInfoByClass[[obj objectForKey:kModuleInfoNameKey]]) {
//            [self.BHModuleInfos addObject:obj];
//            }
//            }];
    }
    func registedAllModules() {
        
    }
}
