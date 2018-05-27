/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A shape layer that animates its path inside a block.
 */

private class AnimatingShapeLayer: CAShapeLayer {

    override class func defaultAction(forKey event: String) -> CAAction? {

        if event == "path" {
            return CABasicAnimation(keyPath: event)
        } else {
            return super.defaultAction(forKey: event)
        }

    }

}

/**
 * A layer whose corners are rounded with a continuous mask (“squircle“).
 */

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

    // MARK: - Initialization

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

    // MARK: - Layout

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
