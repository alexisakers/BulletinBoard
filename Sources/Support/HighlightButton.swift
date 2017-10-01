/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A button that provides a visual feedback when the user interacts with it.
 *
 * This style of button works best with a solid background color. Use the `setBackgroundColor`
 * function on `UIButton` to set one.
 */

public class HighlightButton: UIButton {

    // MARK: - Hit Area

    private var _cachedHitArea: CGRect!

    public override var bounds: CGRect {
        didSet {
            _cachedHitArea = makeHitArea()
        }
    }

    private func makeHitArea() -> CGRect {
        let scaleTransform = CGAffineTransform(scaleX: 5/3, y: 5/3)
        let translateTransform = CGAffineTransform(translationX: -frame.width/3, y: -frame.height/3)
        return bounds.applying(scaleTransform).applying(translateTransform)
    }

    /// The area where touches are considered to be inside the button.
    private var hitArea: CGRect {
        return _cachedHitArea ?? makeHitArea()
    }


    // MARK: - Touch Handling

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlight()
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let mainTouch = touches.first else {
            return
        }

        let currentLocation = mainTouch.location(in: self)
        let previousLocation = mainTouch.previousLocation(in: self)

        let containsCurrentLocation = hitArea.contains(currentLocation)
        let containsPreviousLocation = hitArea.contains(previousLocation)

        let isEntering = !containsPreviousLocation && containsCurrentLocation
        let isExiting = containsPreviousLocation && !containsCurrentLocation

        if isEntering {
            highlight()
        } else if isExiting {
            unhighlight()
        }

    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let mainTouch = touches.first else {
            return
        }

        let currentLocation = mainTouch.location(in: self)

        if hitArea.contains(currentLocation) {
            sendActions(for: .touchUpInside)
        }

        unhighlight()

    }

    // MARK: - Transitions

    @objc private func highlight() {

        let animations = {
            self.alpha = 0.5
        }

        UIView.transition(with: self, duration: 0.1, animations: animations)

    }

    @objc private func unhighlight() {

        let animations = {
            self.alpha = 1
        }

        UIView.transition(with: self, duration: 0.1, animations: animations)

    }

}

extension UIButton {

    /**
     * Sets a solid background color for the button.
     */

    public func setBackgroundColor(_ color: UIColor, forState controlState: UIControlState) {

        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: controlState)

    }

}
