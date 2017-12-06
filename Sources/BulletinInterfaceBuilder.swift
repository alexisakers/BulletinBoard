/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * Generates interface elements for bulletins. Use this class to create custom bulletin items with
 * standard components.
 */

@objc open class BulletinInterfaceBuilder: NSObject {

    /// The appearance to use to generate the items.
    @objc public let appearance: BulletinAppearance

    /// Creates a new interface builder.
    @objc public required init(appearance: BulletinAppearance) {
        self.appearance = appearance
    }

    /**
     * Creates a standard title label.
     */

    @objc open func makeTitleLabel(text: String) -> UILabel {

        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = appearance.titleTextColor
        titleLabel.accessibilityTraits |= UIAccessibilityTraitHeader
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true

        titleLabel.font = appearance.makeTitleFont()
        titleLabel.text = text

        return titleLabel

    }

    /**
     * Creates a standard description label.
     */

    @objc open func makeDescriptionLabel() -> UILabel {

        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = appearance.descriptionTextColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = appearance.makeDescriptionFont()

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

    @objc open func makeActionButton(title: String) -> HighlightButtonWrapper {

        let actionButton = HighlightButton(type: .custom)
        actionButton.setBackgroundColor(appearance.actionButtonColor, forState: .normal)
        actionButton.setTitleColor(appearance.actionButtonTitleColor, for: .normal)
        actionButton.contentHorizontalAlignment = .center

        actionButton.setTitle(title, for: .normal)
        actionButton.titleLabel?.font = appearance.makeActionButtonFont()

        actionButton.layer.cornerRadius = 12
        actionButton.clipsToBounds = true

        if let color = appearance.actionButtonBorderColor {
          actionButton.layer.borderColor = color.cgColor
          actionButton.layer.borderWidth = appearance.actionButtonBorderWidth
        }

        let wrapper = HighlightButtonWrapper(button: actionButton)
        wrapper.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        wrapper.heightAnchor.constraint(equalToConstant: 55).isActive = true

        return wrapper

    }

    /**
     * Creates a standard alternative button.
     *
     * The created button will have no background color and a title color set to `tintColor`.
     *
     * - parameter title: The title of the button.
     */

    @objc open func makeAlternativeButton(title: String) -> UIButton {

        let alternativeButton = UIButton(type: .system)
        alternativeButton.setTitle(title, for: .normal)
        alternativeButton.setTitleColor(appearance.alternativeButtonColor, for: .normal)
        alternativeButton.titleLabel?.font = appearance.makeAlternativeButtonFont()

        if let color = appearance.alternativeButtonBorderColor {
          alternativeButton.layer.cornerRadius = 12
          alternativeButton.clipsToBounds = true
          alternativeButton.layer.borderColor = color.cgColor
          alternativeButton.layer.borderWidth = appearance.alternativeButtonBorderWidth
        }

        return alternativeButton

    }

    /**
     * Creates a stack view to contain a group of objects.
     *
     * - parameter spacing: The spacing between elements. Defaults to `10`.
     */

    @objc open func makeGroupStack(spacing: CGFloat = 10) -> UIStackView {

        let buttonsStack = UIStackView()
        buttonsStack.axis = .vertical
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fill
        buttonsStack.spacing = spacing

        return buttonsStack

    }

}
