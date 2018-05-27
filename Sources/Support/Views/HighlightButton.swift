/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A button that provides a visual feedback when the user interacts with it.
 *
 * This style of button works best with a solid background color. Use the `setBackgroundColor`
 * function on `UIButton` to set one.
 */

class HighlightButton: RoundedButton, HighlighterTarget {

    private let highlighter = Highlighter()

    override var bounds: CGRect {
        didSet {
            highlighter.updateBounds(bounds)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        highlighter.target = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        highlighter.target = self
    }

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlighter.handleTouchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlighter.handleTouchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlighter.handleTouchesEnded(touches, with: event)
    }

    // MARK: - Transitions

    func highlight() {

        let animations = {
            self.alpha = 0.5
        }

        UIView.transition(with: self, duration: 0.1, animations: animations)

    }

    func unhighlight() {

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

    func setBackgroundColor(_ color: UIColor, forState controlState: UIControlState) {

        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: controlState)

    }

}

/**
 * A view that wraps a HighlightButton.
 *
 * A wrapper is required to avoid alpha animation issues when unhighlighting the button and performing
 * a bulletin transition.
 */

@objc public class HighlightButtonWrapper: UIView {

    @objc public let button: UIButton

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is unavailable. Use init(button:) instead.")
    }

    init(button: HighlightButton) {

        self.button = button
        super.init(frame: .zero)

        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    }

    public override var intrinsicContentSize: CGSize {
        return button.intrinsicContentSize
    }

}
