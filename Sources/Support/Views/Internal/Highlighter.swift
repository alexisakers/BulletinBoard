/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/// An item that can be highlighted due to a touch event.
protocol HighlighterTarget: class {

    /// Highlight the item.
    func highlight()

    /// Unhighlight the item.
    func unhighlight()

}

/**
 * An object that determines when an item (its target) needs to be highlighted in response to
 * touch events.
 *
 * You must forward the target's `touchesBegan`, `touchesMoved` and `touchesEnded` to this highlighter.
 */

class Highlighter {

    /// The control targeted for highlight.
    weak var target: (UIControl & HighlighterTarget)?

    // MARK: - Hit Area

    private var _cachedHitArea: CGRect!

    private func makeHitArea(bounds: CGRect) -> CGRect {
        let scaleTransform = CGAffineTransform(scaleX: 5/3, y: 5/3)
        let translateTransform = CGAffineTransform(translationX: -bounds.width/3, y: -bounds.height/3)
        return bounds.applying(scaleTransform).applying(translateTransform)
    }

    private var hitArea: CGRect {
        return _cachedHitArea ?? makeHitArea(bounds: target!.bounds)
    }

    // MARK: - Touch Handling

    /**
     * Call this method when the bounds of the target change.
     */

    func updateBounds(_ bounds: CGRect) {
        _cachedHitArea = makeHitArea(bounds: bounds)
    }

    /**
     * Call this method when touches begin on the target.
     */

    func handleTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        target?.highlight()
    }

    /**
     * Call this method when touches move on the target.
     */

    func handleTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let mainTouch = touches.first else {
            return
        }

        let currentLocation = mainTouch.location(in: target!)
        let previousLocation = mainTouch.previousLocation(in: target!)

        let containsCurrentLocation = hitArea.contains(currentLocation)
        let containsPreviousLocation = hitArea.contains(previousLocation)

        let isEntering = !containsPreviousLocation && containsCurrentLocation
        let isExiting = containsPreviousLocation && !containsCurrentLocation

        if isEntering {
            target?.highlight()
        } else if isExiting {
            target?.unhighlight()
        }

    }

    /**
     * Call this method when touches end on the target.
     */

    func handleTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let mainTouch = touches.first else {
            return
        }

        let currentLocation = mainTouch.location(in: target!)

        if hitArea.contains(currentLocation) {
            target?.sendActions(for: .touchUpInside)
        }

        target?.unhighlight()

    }

}
