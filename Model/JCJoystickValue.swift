//
//  JCJoystickValue.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/26.
//

import Foundation

public struct JCJoystickValue {
    public let angle: CGFloat
    public let movementRange: CGFloat
}

extension JCJoystickValue {
    public static var zero: JCJoystickValue {
        return JCJoystickValue(angle: 0, movementRange: 0)
    }
}
