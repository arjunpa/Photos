//
//  ContainerView.swift
//  Stickers
//
//  Created by Arjun P A on 02/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

final class ContainerView: UIView {
    
    private enum Constants {
        static let defaultCornerRadius: CGFloat = 17.4
    }
    
    enum Position: String {
        case all
        case top
        case none
        case bottom
    }
    
    override var bounds: CGRect {
        didSet {
            self.containingLayer.bounds = self.bounds
            self.updateMask()
        }
    }
    
    var positionOfView: String = Position.all.rawValue {
        didSet {
            self.position = Position(rawValue: self.positionOfView) ?? .all
        }
    }
    
    var position: Position = .all {
        didSet {
            self.updateMask()
        }
    }
    
    var cornerRadius: CGFloat = Constants.defaultCornerRadius {
        didSet {
            self.updateMask()
        }
    }
    
    var borderColor: UIColor? {
        didSet {
            self.containingLayer.strokeColor = self.borderColor?.cgColor
            self.updateMask()
        }
    }
    
    var borderWidth: CGFloat = .zero {
        didSet {
            self.containingLayer.lineWidth = self.borderWidth
            self.updateMask()
        }
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.updateMask()
    }
    
    private func configure() {
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    private lazy var containingLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.bounds = self.bounds
        layer.fillColor = nil
        self.layer.addSublayer(layer)
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
        self.setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
        self.setup()
    }
    
    private func updateMask(with position: Position) {
        if position == .none {
            self.layer.mask = nil
        } else {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: {
                                        switch self.position {
                                        case .all:
                                            return [.bottomLeft, .bottomRight, .topLeft, .topRight]
                                        case .top:
                                            return [.topRight, .topLeft]
                                        case .none:
                                            return []
                                        case .bottom:
                                            return [.bottomLeft, .bottomRight]
                                        }
                                    }(),
                                    cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
            let maskLayer = self.layer.mask as? CAShapeLayer ?? CAShapeLayer()
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    private func updateMask() {
        self.updateMask(with: self.position)
        guard self.borderColor != nil else {
            self.containingLayer.removeFromSuperlayer()
            return
        }
        self.layer.addSublayer(self.containingLayer)
        self.containingLayer.path = (self.layer.mask as? CAShapeLayer ?? CAShapeLayer()).path
    }
}
