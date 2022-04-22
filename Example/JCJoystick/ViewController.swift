//
//  ViewController.swift
//  JCJoystick
//
//  Created by JoongChangYang on 04/14/2022.
//  Copyright (c) 2022 JoongChangYang. All rights reserved.
//

import UIKit
import JCJoystick

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }

}

final class JotstickView: JCJoystickView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var boundaryView: UIView {
        return UIView()
    }
    
    override var thumbView: UIView {
        return UIView()
    }
}
