//
//  JCJoystickView.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/22.
//

import UIKit

open class JCJoystickView: UIView {
    
    private let _boundaryView = UIImageView()
    private let _thumbView = JCJoystickThumbView()
    
    open var boundaryView: UIView {
        self._boundaryView
    }
    
    open var thumbView: UIView {
        self._thumbView
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
    
    private var radius: CGFloat {
        return min(self.bounds.width, self.bounds.height) / 2
    }
    
    private func setupAttribute() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        self.addGestureRecognizer(gesture)
        
        self._boundaryView.backgroundColor = .gray
        self._thumbView.backgroundColor = .lightGray
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
        
        self.addSubview(self.thumbView)
        self.thumbView.translatesAutoresizingMaskIntoConstraints = false
        
        [self.thumbView.centerXAnchor.constraint(equalTo: self.boundaryView.centerXAnchor),
         self.thumbView.centerYAnchor.constraint(equalTo: self.boundaryView.centerYAnchor),
         self.thumbView.widthAnchor.constraint(equalTo: self.boundaryView.widthAnchor, multiplier: 0.3),
         self.thumbView.heightAnchor.constraint(equalTo: self.thumbView.widthAnchor)].forEach { $0.isActive = true }
        
        
    }
    
    @objc
    private func panGesture(_ sender: UIPanGestureRecognizer) {
        print(sender.translation(in: self))
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
