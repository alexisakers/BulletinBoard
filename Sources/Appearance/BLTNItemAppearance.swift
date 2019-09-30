/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * An object that defines the appearance of bulletin items.
 */

@objc public class BLTNItemAppearance: NSObject {

    // MARK: - Color Customization

    /// The tint color to apply to the action button (default `.link` on iOS 13 and `.blue` on older systems).
    @objc public var actionButtonColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .link
        } else {
           return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }()
    
    /// The button image to apply to the action button
    @objc public var actionButtonImage: UIImage?

    /// The title color to apply to action button (default white).
    @objc public var actionButtonTitleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    /// The border color to apply to action button.
    @objc public var actionButtonBorderColor: UIColor? = nil

    /// The border width to apply to action button.
    @objc public var actionButtonBorderWidth: CGFloat = 1.0

    /// The title color to apply to the alternative button (default `.link` on iOS 13 and `.blue` on older systems).
    @objc public var alternativeButtonTitleColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .link
        } else {
            return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }()

    /// The border color to apply to the alternative button.
    @objc public var alternativeButtonBorderColor: UIColor? = nil

    /// The border width to apply to the alternative button.
    @objc public var alternativeButtonBorderWidth: CGFloat = 1.0

    /// The tint color to apply to the imageView (if image rendered in template mode, default `.link` on iOS 13 and `.blue` on older systems).
    @objc public var imageViewTintColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .link
        } else {
            return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }()

    /// The color of title text labels (default `.secondaryLabel` on iOS 13 and light gray on older systems).
    @objc public var titleTextColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return #colorLiteral(red: 0.568627451, green: 0.5647058824, blue: 0.5725490196, alpha: 1)
        }
    }()

    /// The color of description text labels (default `.label` on iOS 13 and black on older systems).
    @objc public var descriptionTextColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }()

    // MARK: - Corner Radius Customization

    /// The corner radius of the action button (default 12).
    @objc public var actionButtonCornerRadius: CGFloat = 12

    /// The corner radius of the alternative button (default 12).
    @objc public var alternativeButtonCornerRadius: CGFloat = 12

    // MARK: - Font Customization

    /// An optional custom font to use for the title label. Set this to nil to use the system font.
    @objc public var titleFontDescriptor: UIFontDescriptor?

    /// An optional custom font to use for the description label. Set this to nil to use the system font.
    @objc public var descriptionFontDescriptor: UIFontDescriptor?

    /// An optional custom font to use for the buttons. Set this to nil to use the system font.
    @objc public var buttonFontDescriptor: UIFontDescriptor?

    /**
     * Whether the description text should be displayed with a smaller font.
     *
     * You should set this to `true` if your text is long (more that two sentences).
     */

    @objc public var shouldUseCompactDescriptionText: Bool = false


    // MARK: - Font Constants

    /// The font size of title elements (default 30).
    @objc public var titleFontSize: CGFloat = 30

    /// The font size of description labels (default 20).
    @objc public var descriptionFontSize: CGFloat = 20

    /// The font size of compact description labels (default 15).
    @objc public var compactDescriptionFontSize: CGFloat = 15

    /// The font size of action buttons (default 17).
    @objc public var actionButtonFontSize: CGFloat = 17

    /// The font size of alternative buttons (default 15).
    @objc public var alternativeButtonFontSize: CGFloat = 15

}

// MARK: - Font Factories

extension BLTNItemAppearance {

    /**
     * Creates the font for title labels.
     */

    @objc public func makeTitleFont() -> UIFont {

        if let titleFontDescriptor = self.titleFontDescriptor {
            return UIFont(descriptor: titleFontDescriptor, size: titleFontSize)
        } else {
            return UIFont.systemFont(ofSize: titleFontSize, weight: .medium)
        }

    }

    /**
     * Creates the font for description labels.
     */

    @objc public func makeDescriptionFont() -> UIFont {

        let size = shouldUseCompactDescriptionText ? compactDescriptionFontSize : descriptionFontSize

        if let descriptionFontDescriptor = self.descriptionFontDescriptor {
            return UIFont(descriptor: descriptionFontDescriptor, size: size)
        } else {
            return UIFont.systemFont(ofSize: size)
        }

    }

    /**
     * Creates the font for action buttons.
     */

    @objc public func makeActionButtonFont() -> UIFont {

        if let buttonFontDescriptor = self.buttonFontDescriptor {
            return UIFont(descriptor: buttonFontDescriptor, size: actionButtonFontSize)
        } else {
            return UIFont.systemFont(ofSize: actionButtonFontSize, weight: .semibold)
        }

    }

    /**
     * Creates the font for alternative buttons.
     */

    @objc public func makeAlternativeButtonFont() -> UIFont {

        if let buttonFontDescriptor = self.buttonFontDescriptor {
            return UIFont(descriptor: buttonFontDescriptor, size: alternativeButtonFontSize)
        } else {
            return UIFont.systemFont(ofSize: alternativeButtonFontSize, weight: .semibold)
        }

    }

}

// MARK: - Status Bar

/**
 * Styles of status bar to use with bulletin items.
 */

@objc public enum BLTNStatusBarAppearance: Int {

    /// The status bar is hidden.
    case hidden

    /// The color of the status bar is determined automatically. This is the default style.
    case automatic

    /// Style to use with dark backgrounds.
    case lightContent

    /// Style to use with light backgrounds.
    case darkContent

}
