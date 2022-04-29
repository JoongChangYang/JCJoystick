//
//  JCJoystickViewDelegate.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/28.
//

import Foundation

public protocol JCJoystickViewDelegate: AnyObject {
    func joystickView(joystickView: JCJoystickView, shouldDrag value: JCJoystickValue) -> Bool
    func joystickView(joystickView: JCJoystickView, beganDrag value: JCJoystickValue)
    func joystickView(joystickView: JCJoystickView, didDrag value: JCJoystickValue)
    func joystickView(joystickView: JCJoystickView, didEndDrag value: JCJoystickValue)
}

public extension JCJoystickViewDelegate {
    func joystickView(joystickView: JCJoystickView, shouldDrag value: JCJoystickValue) -> Bool { true }
    func joystickView(joystickView: JCJoystickView, beganDrag value: JCJoystickValue) {}
    func joystickView(joystickView: JCJoystickView, didDrag value: JCJoystickValue) {}
    func joystickView(joystickView: JCJoystickView, didEndDrag value: JCJoystickValue) {}
}
