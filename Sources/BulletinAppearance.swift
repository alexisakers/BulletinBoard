/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A class that provides appearance customization for bulletin items.
 */

@objc open class BulletinAppearance: NSObject {

    // MARK: - Color Customization

    /// The tint color to apply to the action button.
    @objc public var actionButtonColor: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)

    /// The title color to apply to action button.
    @objc public var actionButtonTitleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    /// The border color to apply to action button
    @objc public var actionButtonBorderColor: UIColor? = nil

    /// The border width to apply to action button
    @objc public var actionButtonBorderWidth: CGFloat = 1.0

    /// The tint color to apply to the alternative button.
    @objc public var alternativeButtonColor: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)

    /// The border color to apply to the alternative button
    @objc public var alternativeButtonBorderColor: UIColor? = nil

    /// The border width to apply to the alternative button
    @objc public var alternativeButtonBorderWidth: CGFloat = 1.0

    /// The tint color to apply to the imageView (if image rendered in template mode).
    @objc public var imageViewTintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)

    /// The color of title text labels.
    @objc public var titleTextColor = #colorLiteral(red: 0.568627451, green: 0.5647058824, blue: 0.5725490196, alpha: 1)

    /// The color of description text labels.
    @objc public var descriptionTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

    // MARK: - Font Customization

    /**
     * An optional custom font to use for the title label. Set this to nil to use the system font.
     */

    @objc public var titleFontDescriptor: UIFontDescriptor? = nil

    /**
     * An optional custom font to use for the description label. Set this to nil to use the system font.
     */

    @objc public var descriptionFontDescriptor: UIFontDescriptor?

    /**
     * An optional custom font to use for the buttons. Set this to nil to use the system font.
     */

    @objc public var buttonFontDescriptor: UIFontDescriptor?

    /**
     * Whether the description text should be displayed with a smaller font.
     *
     * You should set this to `true` if your text is long (more that two sentences).
     */

    @objc public var shouldUseCompactDescriptionText: Bool = false

    // MARK: - Font Constants

    /// The font size of title elements.
    @objc public let titleFontSize: CGFloat = 30

    /// The font size of description labels.
    @objc public let descriptionFontSize: CGFloat = 20

    /// The font size of compact description labels.
    @objc public let compactDescriptionFontSize: CGFloat = 15

    /// The font size of action buttons.
    @objc public let actionButtonFontSize: CGFloat = 17

    /// The font size of alternative buttons.
    @objc public let alternativeButtonFontSize: CGFloat = 15

}

// MARK: - Font Factories

extension BulletinAppearance {

    /**
     * Creates the font for title labels.
     */

    open func makeTitleFont() -> UIFont {

        if let titleFontDescriptor = self.titleFontDescriptor {
            return UIFont(descriptor: titleFontDescriptor, size: titleFontSize)
        } else {
            return UIFont.systemFont(ofSize: titleFontSize, weight: UIFontWeightMedium)
        }

    }

    /**
     * Creates the font for description labels.
     */

    open func makeDescriptionFont() -> UIFont {

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

    open func makeActionButtonFont() -> UIFont {

        if let buttonFontDescriptor = self.buttonFontDescriptor {
            return UIFont(descriptor: buttonFontDescriptor, size: actionButtonFontSize)
        } else {
            return UIFont.systemFont(ofSize: actionButtonFontSize, weight: UIFontWeightSemibold)
        }

    }

    /**
     * Creates the font for alternative buttons.
     */

    open func makeAlternativeButtonFont() -> UIFont {

        if let buttonFontDescriptor = self.buttonFontDescriptor {
            return UIFont(descriptor: buttonFontDescriptor, size: alternativeButtonFontSize)
        } else {
            return UIFont.systemFont(ofSize: alternativeButtonFontSize, weight: UIFontWeightSemibold)
        }

    }

}

// MARK: - Status Bar

/**
 * Styles of status bar to use with bulletin items.
 */

@objc public enum BulletinStatusBarAppearance: Int {

    /// The status bar is hidden.
    case hidden

    /// The color of the status bar is determined automatically. This is the efault style.
    case automatic

    /// Style to use with dark backgrounds.
    case lightContent

    /// Style to use with light backgrounds.
    case darkContent

}

// MARK: - Swift Compatibility

#if swift(>=4.0)
    let UIFontWeightMedium = UIFont.Weight.medium
    let UIFontWeightSemibold = UIFont.Weight.semibold
#endif
