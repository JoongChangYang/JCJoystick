//
//  JCJoystickView.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/22.
//

import UIKit

open class JCJoystickView: UIView {
    
    private let _boundaryView = JCJoystickBoundaryView()
    private let _thumbView = JCCircleView()
    
    open var boundaryView: JCJoystickBoundaryView {
        self._boundaryView
    }
    
    open var thumbView: JCCircleView {
        self._thumbView
    }
    
    open var maximumRadius: CGFloat {
        return self.boundaryView.radius - self.thumbView.radius
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupAttribute()
        self.setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupAttribute()
        self.setupLayout()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let boundaryRadius = self.boundaryImage == nil ? min(self.boundaryView.bounds.width, self.boundaryView.bounds.height) / 2: 0
        self.boundaryView.layer.cornerRadius = boundaryRadius
    }
    
    open func beganDrag(location: CGPoint) {
        self.moveThumbView(location: location)
    }
    
    open func dragging(location: CGPoint) {
        self.moveThumbView(location: location)
    }
    
    open func endDrag() {
        self.thumbView.center = self.boundaryView.centerPoint
    }
}

extension JCJoystickView {
    public var boundaryImage: UIImage? {
        get { self._boundaryView.image }
        set { self._boundaryView.image = newValue }
    }
    
    public var thumbImage: UIImage? {
        get { self._thumbView.image }
        set { self._thumbView.image = newValue }
    }
}

extension JCJoystickView {
    private func setupAttribute() {
        self._boundaryView.backgroundColor = .gray
        self._thumbView.backgroundColor = .lightGray
        self._boundaryView.delegate = self
    }
    
    private func setupLayout() {
        self.addSubview(self.boundaryView)
        self.boundaryView.translatesAutoresizingMaskIntoConstraints = false
        
        [self.boundaryView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
         self.boundaryView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
         self.boundaryView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor),
         self.boundaryView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
         self.boundaryView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
         self.boundaryView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
         self.boundaryView.widthAnchor.constraint(equalTo: self.boundaryView.heightAnchor),
         self.boundaryView.heightAnchor.constraint(equalTo: self.boundaryView.widthAnchor)].forEach { $0.isActive = true }

        [self.boundaryView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
         self.boundaryView.topAnchor.constraint(equalTo: self.topAnchor),
         self.boundaryView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         self.boundaryView.bottomAnchor.constraint(equalTo: self.bottomAnchor)].forEach { constraint in
            constraint.priority = .init(999)
            constraint.isActive = true
        }
        
        self.boundaryView.addSubview(self.thumbView)
        self.thumbView.translatesAutoresizingMaskIntoConstraints = false
        
        [self.thumbView.centerXAnchor.constraint(equalTo: self.boundaryView.centerXAnchor),
         self.thumbView.centerYAnchor.constraint(equalTo: self.boundaryView.centerYAnchor),
         self.thumbView.widthAnchor.constraint(equalTo: self.boundaryView.widthAnchor, multiplier: 0.3),
         self.thumbView.heightAnchor.constraint(equalTo: self.thumbView.widthAnchor)].forEach { $0.isActive = true }
    }
    
    private func moveThumbView(location: CGPoint) {
        let currentDistance = self.straightDistance(center: self.boundaryView.centerPoint, location: location)
        
        if self.maximumRadius >= currentDistance {
            self.thumbView.center = location
        } else {
            
        }
    }
    
    private func radian() {
        
    }
    
    private func gap(center: CGPoint, location: CGPoint) -> CGSize {
        let horizontal = center.x - location.x
        let vertical = center.y - location.y
        return CGSize(width: horizontal, height: vertical)
    }
    
    private func straightDistance(center: CGPoint, location: CGPoint) -> CGFloat {
        let gap = self.gap(center: center, location: location)
        let squaredX = gap.width * gap.width
        let squaredY = gap.height * gap.height
        return sqrt(squaredX + squaredY)
    }
}

extension JCJoystickView: JCJoystickBoundaryViewDelegate {
    func boundaryView(event: JCJoystickBoundaryView.Event) {
        switch event {
        case .began(let location):
            self.beganDrag(location: location)
        case .moved(let location):
            self.dragging(location: location)
        case .end:
            self.endDrag()
        }
    }
}