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

    @IBOutlet private weak var joystickView: JCJoystickView!
    @IBOutlet private weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    private func setupUI() {
        self.textView.backgroundColor = .white
        self.textView.layer.cornerRadius = 8
        self.textView.layer.borderWidth = 2
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
    }

}

final class JotstickView: JCJoystickView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var boundaryView: JCJoystickBoundaryView {
        return .init()
    }
    
    override var thumbView: JCCircleView {
        return .init()
    }
}
