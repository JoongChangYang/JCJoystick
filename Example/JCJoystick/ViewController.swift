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
    
    @IBOutlet private weak var angleLabel: UILabel!
    @IBOutlet private weak var rangeLabel: UILabel!
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
        switch self.angleValueType {
        case .degree:
            self.angleLabel.text = "degree: \(value.angle)"
        case .radian:
            self.angleLabel.text = "radian: \(value.angle)"
        }
        
        self.rangeLabel.text = "range: \(value.movementRange)"
    }
    
    
    @IBAction private func selectedAngleType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.angleValueType = .degree
        case 1:
            self.angleValueType = .radian
        default:
            break
        }
        self.log(value: .zero)
    }
    
}

extension ViewController: JCJoystickViewDelegate {
    func joystickView(joystickView: JCJoystickView, value: JCJoystickValue) {
        self.log(value: value)
    }
}
