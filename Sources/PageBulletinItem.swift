/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A standard bulletin item with a title and optional additional informations. It can display a large
 * action button and a smaller button for alternative options.
 *
 * You can override this class to add custom button handling. Override the `actionButtonTapped(sender:)`
 * and `alternativeButtonTapped(sender:)` to handle tap events. Make sure to call `super` if you do.
 */

open class PageBulletinItem: BulletinItem {

    // MARK: Initialization

    /**
     * Creates a bulletin page with the specified title.
     *
     * - parameter title: The title of the page.
     */

    public init(title: String) {
        self.title = title
    }


    // MARK: - Page Contents

    /// The title of the page.
    public let title: String

    /// An image to display below the title. Should be less than or equal to 128x128px.
    public var image: UIImage?
    
    /// An accessibility label which gets announced to VoiceOver users if the image gets focused.
    public var imageAccessibilityLabel: String?

    /// A description text to display below the image.
    public var descriptionText: String?

    /// The title of the action button.
    public var actionButtonTitle: String?

    /// The title of the alternative button.
    public var alternativeButtonTitle: String?


    // MARK: - BulletinItem

    /**
     * The current object managing the item.
     *
     * This property is set when the item is currently being displayed. It will be set to `nil` when
     * the item is removed from view.
     */

    public weak var manager: BulletinManager?

    /**
     * Whether the page can be dismissed.
     *
     * If you set this value to `true`, the user will be able to dismiss the bulletin by tapping outside
     * the card.
     *
     * You should set it to `true` for the last item you want to display.
     */

    public var isDismissable: Bool = false

    /**
     * The item to display after this one.
     *
     * If you set this value, you'll be able to call `displayNextItem()` to present the next item to
     * the stack.
     */

    public var nextItem: BulletinItem? = nil

    
    // MARK: - Customization

    /**
     * The interface factory used to generate the interface of the page.
     *
     * Use this property to customize the appearance of the generated elements.
     */

    public let interfaceFactory = BulletinInterfaceFactory()

    /**
     * Whether the description text should be displayed with a smaller font.
     *
     * You should set this to `true` if your text is long (more that two sentences).
     */

    public var shouldCompactDescriptionText: Bool = false


    // MARK: - Buttons

    fileprivate var actionButton: ContainerView<HighlightButton>? = nil
    fileprivate var alternativeButton: UIButton? = nil

    /**
     * The code to execute when the action button is pressed.
     */

    public var actionHandler: ((PageBulletinItem) -> Void)? = nil

    /**
     * The code to execute when the alternative button is pressed.
     */

    public var alternativeHandler: ((PageBulletinItem) -> Void)? = nil

    /**
     * Handles a tap on the action button.
     *
     * You can override this method to add custom tap handling. You have to call `super.actionButtonTapped(sender:)`
     * in your implementation.
     */

    @objc open func actionButtonTapped(sender: UIButton) {
        actionHandler?(self)
    }

    /**
     * Handles a tap on the alternative button.
     *
     * You can override this method to add custom tap handling. You have to call `super.alternativeButtonTapped(sender:)`
     * in your implementation.
     */

    @objc open func alternativeButtonTapped(sender: UIButton) {
        alternativeHandler?(self)
    }


    // MARK: - View Management

    /**
     * Creates the list of views to display on the bulletin.
     *
     * This is an implementation detail of `BulletinItem` and you should not call it directly.
     */

    public func makeArrangedSubviews() -> [UIView] {

        var arrangedSubviews = [UIView]()

        // Title Label

        let titleLabel = interfaceFactory.makeTitleLabel()
        titleLabel.text = title
        arrangedSubviews.append(titleLabel)

        // Image View

        if let image = self.image {

            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 128).isActive = true
            
            if let imageAccessibilityLabel = imageAccessibilityLabel {
                imageView.isAccessibilityElement = true
                imageView.accessibilityLabel = imageAccessibilityLabel
            }

            arrangedSubviews.append(imageView)

        }

        // Description Label

        if let descriptionText = self.descriptionText {

            let descriptionLabel = interfaceFactory.makeDescriptionLabel(isCompact: shouldCompactDescriptionText)
            descriptionLabel.text = descriptionText
            arrangedSubviews.append(descriptionLabel)

        }

        // Buttons Stack

        let buttonsStack = interfaceFactory.makeGroupStack()

        if let actionButtonTitle = self.actionButtonTitle {

            let actionButton = interfaceFactory.makeActionButton(title: actionButtonTitle)
            buttonsStack.addArrangedSubview(actionButton)
            actionButton.contentView.addTarget(self, action: #selector(actionButtonTapped(sender:)), for: .touchUpInside)

            self.actionButton = actionButton

        }

        if let alternativeButtonTitle = self.alternativeButtonTitle {

            let alternativeButton = interfaceFactory.makeAlternativeButton(title: alternativeButtonTitle)
            buttonsStack.addArrangedSubview(alternativeButton)
            alternativeButton.addTarget(self, action: #selector(alternativeButtonTapped(sender:)), for: .touchUpInside)

            self.alternativeButton = alternativeButton

        }

        arrangedSubviews.append(buttonsStack)
        return arrangedSubviews

    }

    /**
     * Called by the manager when the item was removed from the bulletin view. Use this function
     * to remove any button target or gesture recognizers from your managed views.
     *
     * This is an implementation detail of `BulletinItem` and you should not call it directly.
     */

    public func tearDown() {
        actionButton?.contentView.removeTarget(self, action: nil, for: .touchUpInside)
        alternativeButton?.removeTarget(self, action: nil, for: .touchUpInside)
        actionButton = nil
        alternativeButton = nil
    }

}
