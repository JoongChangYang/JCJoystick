//
//  JCJoystickView.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/22.
//

import UIKit

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

open class JCJoystickView: UIView {
    
    private let _boundaryView = JCJoystickBoundaryView()
    private let _thumbView = JCCircleView()
    private lazy var thumbViewDiameterConstraint = self.thumbView.widthAnchor.constraint(equalToConstant: 50)
    
    public weak var delegate: JCJoystickViewDelegate?
    
    public var angleValueType: JCAngleType = .degree
    public var thumbLimitStyle: JCThumbLimitStyle = .inside
    
    open var boundaryView: JCJoystickBoundaryView {
        self._boundaryView
    }
    
    open var thumbView: JCCircleView {
        self._thumbView
    }
    
    open var maximumRadius: CGFloat? {
        switch self.thumbLimitStyle {
        case .inside:
            return self.boundaryView.radius - self.thumbView.radius
        case .outside:
            return self.boundaryView.radius + self.thumbView.radius
        case .center:
            return self.boundaryView.radius
        case .customWithConstant(constant: let constant):
            return self.boundaryView.radius + constant
        case .customWithMultiplier(multiplier: let multiplier):
            return self.boundaryView.radius * multiplier
        case .unLimited:
            return nil
        }
    }
    
    public var thumbDiameterMultiplier: CGFloat = 0.25 {
        didSet {
            self.updateThumbViewDiameterConstraint()
        }
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
        self.updateThumbViewDiameterConstraint()
    }
    
    open func beganDrag(location: CGPoint) {
        let dragValue = self.dragValue(location: location)
        let value = self.joystickValue(radian: dragValue.radian, movementRange: dragValue.moveMentRange)
        
        guard self.delegate?.joystickView(joystickView: self, shouldDrag: value) ?? true else { return }
        
        self.thumbView.center = dragValue.point
        self.delegate?.joystickView(joystickView: self, beganDrag: value)
        self.delegate?.joystickView(joystickView: self, didDrag: value)
    }
    
    open func dragging(location: CGPoint) {
        let dragValue = self.dragValue(location: location)
        let value = self.joystickValue(radian: dragValue.radian, movementRange: dragValue.moveMentRange)
        
        guard self.delegate?.joystickView(joystickView: self, shouldDrag: value) ?? true else { return }
        
        self.thumbView.center = dragValue.point
        self.delegate?.joystickView(joystickView: self, didDrag: value)
    }
    
    open func endDrag() {
        let dragValue = self.dragValue(location: self.boundaryView.centerPoint)
        let value = self.joystickValue(radian: dragValue.radian, movementRange: dragValue.moveMentRange)
        
        guard self.delegate?.joystickView(joystickView: self, shouldDrag: value) ?? true else { return }
        
        self.thumbView.center = dragValue.point
        self.delegate?.joystickView(joystickView: self, didDrag: value)
        self.delegate?.joystickView(joystickView: self, didEndDrag: value)
    }
    
}

extension JCJoystickView {
    
    private var defaultBoundaryImage: UIImage {
        return self.createDefaultImage(borderColor: .darkGray, borderWidth: 8)
    }
    
    private var defaultThumbImage: UIImage {
        return self.createDefaultImage(borderColor: .gray, borderWidth: 20)
    }
    
    private func createDefaultImage(borderColor: UIColor, borderWidth: CGFloat) -> UIImage {
        let imageSize = CGSize(width: 200, height: 200)
        let view = UIView(frame: .init(origin: .zero, size: imageSize))
        view.backgroundColor = .white
        view.layer.cornerRadius = imageSize.height / 2
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }
    
    private func setupAttribute() {
        self._boundaryView.image = self.defaultBoundaryImage
        self._thumbView.image = self.defaultThumbImage
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
         self.thumbViewDiameterConstraint,
         self.thumbView.heightAnchor.constraint(equalTo: self.thumbView.widthAnchor)].forEach { $0.isActive = true }
    }
    
    private func updateThumbViewDiameterConstraint() {
        let multiplier = self.thumbDiameterMultiplier <= 1 ? self.thumbDiameterMultiplier: 1
        let constant = self.boundaryView.bounds.width * multiplier
        self.thumbViewDiameterConstraint.constant = constant
        self.layoutIfNeeded()
    }
    
    private func dragValue(location: CGPoint) -> DragValue {
        let center = self.boundaryView.centerPoint
        let currentDistance = self.straightDistance(center: center, location: location)
        let radian = self.radian(center: center, location: location)
        
        let newPoint: CGPoint
        let moveMentRange: CGFloat
        
        if let maximumRadius = self.maximumRadius, maximumRadius < currentDistance {
            newPoint = self.maximumPoint(center: center, radius: maximumRadius, radian: radian)
            moveMentRange = 1
        } else {
            newPoint = location
            moveMentRange = currentDistance / (self.maximumRadius ?? self.boundaryView.radius)
        }
        
        return DragValue(point: newPoint, moveMentRange: moveMentRange, radian: radian)
    }
    
    private func joystickValue(radian: CGFloat, movementRange: CGFloat) -> JCJoystickValue {
        let angleValue: CGFloat
        
        switch self.angleValueType {
        case .degree:
            angleValue = radian * (180 / .pi)
        case .radian:
            angleValue = radian
        }
        
        return JCJoystickValue(angle: angleValue, movementRange: movementRange)
    }
    
    private func maximumPoint(center: CGPoint, radius: CGFloat, radian: CGFloat) -> CGPoint {
        let x = center.x + (radius * cos(radian))
        let y = center.y + (radius * sin(radian))
        return CGPoint(x: x, y: y)
    }
    
    private func radian(center: CGPoint, location: CGPoint) -> CGFloat {
        let gap = self.gap(center: center, location: location)
        return atan2(gap.height, gap.width)
    }
    
    private func gap(center: CGPoint, location: CGPoint) -> CGSize {
        let horizontal = location.x - center.x
        let vertical = location.y - center.y
        return CGSize(width: horizontal, height: vertical)
    }
    
    private func straightDistance(center: CGPoint, location: CGPoint) -> CGFloat {
        let gap = self.gap(center: center, location: location)
        let squaredX = gap.width * gap.width
        let squaredY = gap.height * gap.height
        return sqrt(squaredX + squaredY)
    }
}

extension JCJoystickView {
    public var boundaryImage: UIImage? {
        get { self._boundaryView.image }
        set { self._boundaryView.image = newValue }
    }
    
    public var boundaryImageView: UIImageView {
        return self.boundaryView.imageView
    }
    
    public var thumbImage: UIImage? {
        get { self._thumbView.image }
        set { self._thumbView.image = newValue }
    }
    
    public var thumbImageView: UIImageView {
        return self.thumbView.imageView
    }
}

extension JCJoystickView: JCJoystickBoundaryViewDelegate {
    func boundaryView(boundaryView: JCJoystickBoundaryView, event: JCJoystickBoundaryView.Event) {
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

extension JCJoystickView {
    struct DragValue {
        let point: CGPoint
        let moveMentRange: CGFloat
        let radian: CGFloat
    }
}
