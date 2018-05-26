/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

protocol HighlighterTarget: class {
    func highlight()
    func unhighlight()
}

class Highlighter {

    weak var target: (UIControl & HighlighterTarget)?

    // MARK: - Hit Area

    private var _cachedHitArea: CGRect!

    private func makeHitArea(bounds: CGRect) -> CGRect {
        let scaleTransform = CGAffineTransform(scaleX: 5/3, y: 5/3)
        let translateTransform = CGAffineTransform(translationX: -bounds.width/3, y: -bounds.height/3)
        return bounds.applying(scaleTransform).applying(translateTransform)
    }

    /// The area where touches are considered to be inside the button.
    private var hitArea: CGRect {
        return _cachedHitArea ?? makeHitArea(bounds: target!.bounds)
    }

    // MARK: - Touch Handling

    func updateBounds(_ bounds: CGRect) {
        _cachedHitArea = makeHitArea(bounds: bounds)
    }

    func handleTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        target?.highlight()
    }

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
