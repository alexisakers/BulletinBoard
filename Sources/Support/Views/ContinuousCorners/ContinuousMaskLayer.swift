//
//  ContinuousMaskLayer.swift
//  BLTNBoard
//
//  Created by Alexis AUBRY on 5/25/18.
//  Copyright © 2018 Bulletin. All rights reserved.
//

import UIKit

private class AnimatingShapeLayer: CAShapeLayer {

    override class func defaultAction(forKey event: String) -> CAAction? {

        if event == "path" {
            return CABasicAnimation(keyPath: event)
        } else {
            return super.defaultAction(forKey: event)
        }

    }

}

class ContinuousMaskLayer: CALayer {

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
    }

    override init() {
        super.init()
        self.mask = AnimatingShapeLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        refreshMask()
    }

    private func refreshMask() {

        guard let mask = mask as? CAShapeLayer else {
            return
        }

        let radii = CGSize(width: continuousCornerRadius, height: continuousCornerRadius)
        let roundedPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundedCorners, cornerRadii: radii)

        mask.path = roundedPath.cgPath

    }

}
