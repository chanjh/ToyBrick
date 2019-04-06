//
//  Middle.swift
//  Middle
//
//  Created by 陈嘉豪 on 2019/4/5.
//

import Foundation
import ToyBrick
import Module001

public class Middle {
    public static let shared = Middle()
    public func registerModule001() {
        ToyBrick.shared.register(Module001Protocol.self) { () -> Module001Protocol? in
            return Module001(TBContext.shared)
        }
    }
    
    public func makeModule001() -> Module001Protocol? {
        return ToyBrick.shared.create(Module001Protocol.self)
    }
}
