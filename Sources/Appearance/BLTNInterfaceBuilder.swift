/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * Generates interface elements for bulletins. Use this class to create custom bulletin items with
 * standard components.
 */

@objc open class BLTNInterfaceBuilder: NSObject {

    /// The item for which the interface builder was created.
    @objc public weak var item: BLTNItem?

    /// The appearance to use to generate the items.
    @objc public let appearance: BLTNItemAppearance

    /// Creates a new interface builder.
    @objc public required init(appearance: BLTNItemAppearance, item: BLTNItem) {
        self.appearance = appearance
        self.item = item
    }

    /**
     * Creates a standard title label.
     */

    @objc open func makeTitleLabel() -> BLTNTitleLabelContainer {

        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = appearance.titleTextColor
        titleLabel.accessibilityTraits.insert(.header)
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.lineBreakMode = .byWordWrapping

        titleLabel.font = appearance.makeTitleFont()

        let needsCloseButton = item?.isDismissable == true && item?.requiresCloseButton == true
        let inset: CGFloat = needsCloseButton ? 12 + 30 : 0

        return BLTNTitleLabelContainer(label: titleLabel, horizontalInset: inset)

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
     * Creates a standard text field with an optional delegate.
     *
     * - parameter placeholder: The placeholder text.
     * - parameter returnKey: The type of return key to apply to the text field.
     * - parameter delegate: The delegate for the text field.
     */

    @objc open func makeTextField(placeholder: String? = nil,
                                  returnKey: UIReturnKeyType = .default,
                                  delegate: UITextFieldDelegate? = nil) -> UITextField {

        let textField = UITextField()
        textField.delegate = delegate
        textField.textAlignment = .left
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.returnKeyType = returnKey

        return textField

    }

    /**
     * Creates a standard action (main) button.
     *
     * The created button will have rounded corners, a background color set to the `tintColor` and
     * a title color set to `actionButtonTitleColor`.
     *
     * - parameter title: The title of the button.
     */

    @objc open func makeActionButton(title: String) -> BLTNHighlightButtonWrapper {

        let actionButton = HighlightButton()
        actionButton.cornerRadius = appearance.actionButtonCornerRadius
        actionButton.setBackgroundColor(appearance.actionButtonColor, forState: .normal)
        actionButton.setTitleColor(appearance.actionButtonTitleColor, for: .normal)
        actionButton.contentHorizontalAlignment = .center

        actionButton.setTitle(title, for: .normal)
        actionButton.titleLabel?.font = appearance.makeActionButtonFont()

        actionButton.clipsToBounds = true

        if let color = appearance.actionButtonBorderColor {
          actionButton.layer.borderColor = color.cgColor
          actionButton.layer.borderWidth = appearance.actionButtonBorderWidth
        }

        let wrapper = BLTNHighlightButtonWrapper(button: actionButton)
        wrapper.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let heightConstraint = wrapper.heightAnchor.constraint(equalToConstant: 55)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true

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

        let alternativeButton = RoundedButton()
        alternativeButton.cornerRadius = appearance.alternativeButtonCornerRadius
        alternativeButton.setTitle(title, for: .normal)
        alternativeButton.setTitleColor(appearance.alternativeButtonTitleColor, for: .normal)
        alternativeButton.titleLabel?.font = appearance.makeAlternativeButtonFont()

        if let color = appearance.alternativeButtonBorderColor {
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

    /**
     * Wraps a view without intrinsic content size inside a view with an intrinsic content size.
     *
     * This method allows you to display view without an intrinsic content size, such as collection views,
     * inside stack views; by using the returned `BLTNContentView` view.
     *
     * - parameter view: The view to wrap in the container.
     * - parameter width: The width of the content. Pass `nil` if the content has a flexible width.
     * - parameter height: The height of the content. Pass `nil` if the content has a flexible height.
     * - parameter position: The position of `view` inside its parent.
     *
     * - returns: The view that contains the `view` and an intrinsic content size. You can add the returned
     * view to a stack view.
     */

    @objc open func wrapView(_ view: UIView, width: NSNumber?, height: NSNumber?, position: BLTNViewPosition) -> BLTNContainerView {

        let container = BLTNContainerView()

        container.contentSize = CGSize(width: width.flatMap(CGFloat.init) ?? UIView.noIntrinsicMetric,
                                       height: height.flatMap(CGFloat.init) ?? UIView.noIntrinsicMetric)

        container.setChildView(view) { parent, child in

            switch position {
            case .centered:
                child.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
                child.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true

            case .pinnedToEdges:
                child.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
                child.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
                child.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
                child.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
            }

        }

        return container

    }

}
