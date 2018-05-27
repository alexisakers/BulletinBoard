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
