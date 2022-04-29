//
//  JCThumbLimitStyle.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/27.
//

import Foundation

public enum JCThumbLimitStyle {
    case inside
    case outside
    case center
    case customWithConstant(constant: CGFloat)
    case customWithMultiplier(multiplier: CGFloat)
    case unlimited
}
