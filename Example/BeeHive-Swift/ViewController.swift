//
//  ViewController.swift
//  BeeHive-Swift
//
//  Created by 陈嘉豪 on 2019/3/27.
//  Copyright © 2019 Gill Chan. All rights reserved.
//

import UIKit
import ToyBrick

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let instance = BeeHive.shared.create(FirstServiceProtocol.self)
        instance?.testFunc()
    }
}
