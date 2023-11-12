//
//  ViewController.swift
//  ToyBrick-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import Middle
import ToyBrick
import UIKit

class ViewController: UIViewController {
    lazy var actionButton1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("测试1", for: .normal)
        button.addTarget(self, action: #selector(onButton1TapAction(_:)), for: .touchUpInside)
        return button
    }()
    
    // event
    @objc private func onButton1TapAction(_ sender: UIButton) {
//        Middle.shared.makeModule001().tr
        
//        ToyBrick.shared.
        
        ModuleManager.shared.triggerEvent(.didCustomEvent, param: ["userInfo": "aaaaaaaa"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton1.frame = CGRect(x: 0, y: 100, width: 80, height: 35)
        view.addSubview(actionButton1)
        
        print("Function: \(#function)")
        let instance = ToyBrick.shared.create(FirstServiceProtocol.self)
        instance?.testFunc()
        Middle.shared.makeModule001()?.moduleFunc()
    }
}
