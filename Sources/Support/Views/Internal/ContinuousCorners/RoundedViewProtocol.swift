/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A view with rounded corners. Adopt this protocol if your view's layer is a `ContinuousMaskLayer`.
 * This protocol provides utilities to easily change the rounded corners.
 *
 * You need to override `+ (Class *)layerClass` on `UIView` before conforming to this protocol.
 */

protocol RoundedViewProtocol: NSObjectProtocol {
    var layer: CALayer { get }
}

extension RoundedViewProtocol {

    /// The corner radius of the view.
    var cornerRadius: CGFloat {
        get {
            return roundedLayer.continuousCornerRadius
        }
        set {
            roundedLayer.continuousCornerRadius = newValue
        }
    }

    /// The corners to round.
    var roundedCorners: UIRectCorner {
        get {
            return roundedLayer.roundedCorners
        }
        set {
            roundedLayer.roundedCorners = newValue
        }
    }

    private var roundedLayer: ContinuousMaskLayer {
        return layer as! ContinuousMaskLayer
    }

}
