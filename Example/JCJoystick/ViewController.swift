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

    private var angleValueType: JCAngleType = .degree {
        didSet { self.joystickView.angleValueType = self.angleValueType }
    }
    
    @IBOutlet private weak var logLabel: UILabel!
    @IBOutlet private weak var joystickView: JCJoystickView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    private func setupUI() {
        self.joystickView.delegate = self
        self.log(value: .zero)
    }

    private func log(value: JCJoystickValue) {
        var text: String
        
        switch self.angleValueType {
        case .degree:
            text = "degree: \(value.angle)"
        case .radian:
            text = "radian: \(value.angle)"
        }
        
        text += "\nmoveMentRange: \(value.movementRange)"
        
        self.logLabel.text = text
    }
}

extension ViewController: JCJoystickViewDelegate {
    func joystickView(joystickView: JCJoystickView, value: JCJoystickValue) {
        print(value)
        self.log(value: value)
    }
}
