//
//  ContinuousMaskLayer.swift
//  BLTNBoard
//
//  Created by Alexis AUBRY on 5/25/18.
//  Copyright © 2018 Bulletin. All rights reserved.
//

import UIKit

class ContinuousMaskLayer: CALayer {

    private let maskLayer = CAShapeLayer()

    /// The corner radius.
    var continuousCornerRadius: CGFloat = 0 {
        didSet {
            refreshMask()
        }
    }

    /// The corners to round.
    var roundedCorners: UIRectCorner = .allCorners {
        didSet {
            refreshMask()
        }
    }

    override init(layer: Any) {
        super.init(layer: layer)
        self.mask = maskLayer
    }

    override init() {
        super.init()
        self.mask = maskLayer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        refreshMask()
    }

    private func refreshMask() {

        let radii = CGSize(width: continuousCornerRadius, height: continuousCornerRadius)
        let roundedPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundedCorners, cornerRadii: radii)

        maskLayer.path = roundedPath.cgPath

    }

}
