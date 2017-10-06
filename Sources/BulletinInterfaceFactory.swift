/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * Generates interface elements for bulletins. Use this class to create custom bulletin items witg
 * standard components.
 */

public class BulletinInterfaceFactory {

    /**
     * Creates a new interface factory with the default configuration.
     */

    public init() {}

    // MARK: - Customization

    /// The tint color to apply to button elements.
    public var tintColor: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)

    /// The title color to apply to action button.
    public var actionButtonTitleColor = UIColor.white


    // MARK: - Fonts

    /// The font size of title elements.
    public let titleFontSize: CGFloat = 30

    /// The font size of description labels.
    public let descriptionFontSize: CGFloat = 20

    /// The font size of compact description labels.
    public let compactDescriptionFontSize: CGFloat = 15

    /// The font size of action buttons.
    public let actionButtonFontSize: CGFloat = 17


    // MARK: - Colors

    /// The color of title text labels.
    public let titleTextColor = #colorLiteral(red: 0.568627451, green: 0.5647058824, blue: 0.5725490196, alpha: 1)

    /// The color of description text labels.
    public let descriptionTextColor = UIColor.black

    
    // MARK: - Factories

    /**
     * Creates a standard title label.
     */

    public func makeTitleLabel() -> UILabel {

        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = titleTextColor
        titleLabel.accessibilityTraits |= UIAccessibilityTraitHeader
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true

        titleLabel.font = UIFont.systemFont(ofSize: titleFontSize, weight: UIFontWeightMedium)

        return titleLabel

    }

    /**
     * Creates a standard title label.
     *
     * - parameter isCompact: If `true`, a smaller font size will be used.
     */

    public func makeDescriptionLabel(isCompact: Bool) -> UILabel {

        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = descriptionTextColor
        descriptionLabel.numberOfLines = 0

        let fontSize: CGFloat = isCompact ? compactDescriptionFontSize : descriptionFontSize
        descriptionLabel.font = UIFont.systemFont(ofSize: fontSize)

        return descriptionLabel

    }

    /**
     * Creates a standard action (main) button.
     *
     * The created button will have rounded corners, a background color set to the `tintColor` and
     * a title color set to `actionButtonTitleColor`.
     *
     * - parameter title: The title of the button.
     */

    public func makeActionButton(title: String) -> ContainerView<HighlightButton> {

        let actionButton = HighlightButton(type: .custom)

        actionButton.setBackgroundColor(tintColor, forState: .normal)
        actionButton.setTitleColor(actionButtonTitleColor, for: .normal)

        actionButton.contentHorizontalAlignment = .center
        actionButton.autoresizingMask = .flexibleWidth

        actionButton.setTitle(title, for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: actionButtonFontSize, weight: UIFontWeightSemibold)

        actionButton.layer.cornerRadius = 12
        actionButton.clipsToBounds = true

        let actionContainer = ContainerView<HighlightButton>(actionButton)
        actionContainer.heightAnchor.constraint(equalToConstant: 55).isActive = true

        return actionContainer

    }

    /**
     * Creates a standard alternative button.
     *
     * The created button will have no background color and a title color set to `tintColor`.
     *
     * - parameter title: The title of the button.
     */

    public func makeAlternativeButton(title: String) -> UIButton {

        let alternativeButton = UIButton(type: .system)
        alternativeButton.setTitle(title, for: .normal)
        alternativeButton.setTitleColor(tintColor, for: .normal)

        return alternativeButton

    }

    /**
     * Creates a stack view to contain a group of objects.
     *
     * - parameter spacing: The spacing between elements. Defaults to `10`.
     */

    public func makeGroupStack(spacing: CGFloat = 10) -> UIStackView {

        let buttonsStack = UIStackView()
        buttonsStack.axis = .vertical
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fill
        buttonsStack.spacing = spacing

        return buttonsStack

    }

}

// MARK: - Swift Compatibility

#if swift(>=4.0)
private let UIFontWeightMedium = UIFont.Weight.medium
private let UIFontWeightSemibold = UIFont.Weight.semibold
#endif
