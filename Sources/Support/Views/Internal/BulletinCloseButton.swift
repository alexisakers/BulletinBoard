/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A button to close the bulletin.
 */

class BulletinCloseButton: UIControl, HighlighterTarget {

    private let backgroundContainer = UIView()
    private let closeGlyph = UIImageView()

    private let highlighter = Highlighter()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        highlighter.target = self
        configureSubviews()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        highlighter.target = self
        configureSubviews()
        configureConstraints()
    }

    private func configureSubviews() {

        // Content

        isAccessibilityElement = true
        accessibilityLabel = NSLocalizedString("Close", tableName: "Localizable",
                                               bundle: Bundle(for: BulletinCloseButton.self), comment: "")

        // Layout

        addSubview(backgroundContainer)
        addSubview(closeGlyph)

        backgroundContainer.layer.cornerRadius = 14

        let glyph = UIImage(named: "CloseGlyph", in: Bundle(for: BulletinCloseButton.self), compatibleWith: nil)!
        closeGlyph.image = glyph.withRenderingMode(.alwaysTemplate)
        closeGlyph.clipsToBounds = true

        backgroundContainer.isUserInteractionEnabled = false
        closeGlyph.isUserInteractionEnabled = false

    }

    private func configureConstraints() {

        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        closeGlyph.translatesAutoresizingMaskIntoConstraints = false

        backgroundContainer.widthAnchor.constraint(equalToConstant: 28).isActive = true
        backgroundContainer.heightAnchor.constraint(equalToConstant: 28).isActive = true
        backgroundContainer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundContainer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        closeGlyph.widthAnchor.constraint(equalToConstant: 12).isActive = true
        closeGlyph.heightAnchor.constraint(equalToConstant: 12).isActive = true
        closeGlyph.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor).isActive = true
        closeGlyph.centerYAnchor.constraint(equalTo: backgroundContainer.centerYAnchor).isActive = true

    }

    // MARK: - Customization

    func updateColors(isDarkBackground: Bool) {
        if isDarkBackground {
            backgroundContainer.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            closeGlyph.tintColor = #colorLiteral(red: 0.3764705882, green: 0.3921568627, blue: 0.431372549, alpha: 1)
        } else {
            backgroundContainer.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.3921568627, blue: 0.431372549, alpha: 1)
            closeGlyph.tintColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        }
    }

    // MARK: - Highlighting

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlighter.handleTouchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlighter.handleTouchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlighter.handleTouchesEnded(touches, with: event)
    }

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
