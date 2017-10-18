/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A standard bulletin item with a title and optional additional informations. It can display a large
 * action button and a smaller button for alternative options.
 *
 * You can override this class to customize button tap handling. Override the `actionButtonTapped(sender:)`
 * and `alternativeButtonTapped(sender:)` methods to handle tap events. Make sure to call `super` in your
 * implementations if you do.
 */

open class PageBulletinItem: BulletinItem {

    // MARK: Initialization

    /**
     * Creates a bulletin page with the specified title.
     * - parameter title: The title of the page.
     */

    public init(title: String) {
        self.title = title
    }


    // MARK: - Page Contents

    /// The title of the page.
    public let title: String

    /// An image to display below the title. It should have a size of 128 pixels by 128 pixels.
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
     * The object managing the item.
     *
     * This property is set when the item is currently being displayed. It will be set to `nil` when
     * the item is removed from bulletin.
     */

    public weak var manager: BulletinManager?

    /**
     * Whether the page can be dismissed.
     *
     * If you set this value to `true`, the user will be able to dismiss the bulletin by tapping outside
     * of the card or by swiping down.
     *
     * You should set it to `true` for the last item you want to display.
     */

    public var isDismissable: Bool = false

    /**
     * The block of code to execute when the bulletin item is dismissed. This is called when the bulletin
     * is moved out of view.
     *
     * You can leave it `nil` if `isDismissable` is set to false.
     *
     * - parameter item: The item that is being dismissed. When calling `dismissalHandler`, the manager
     * passes a reference to `self` so you don't have to manage weak references yourself.
     */

    public var dismissalHandler: ((_ item: BulletinItem) -> Void)?

    /**
     * The item to display after this one.
     *
     * If you set this value, you'll be able to call `displayNextItem()` to push the next item to
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
     * The code to execute when the action button is tapped.
     */

    public var actionHandler: ((PageBulletinItem) -> Void)? = nil

    /**
     * The code to execute when the alternative button is tapped.
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

        let titleLabel = interfaceFactory.makeTitleLabel(reading: title)
        arrangedSubviews.append(titleLabel)

        // Image View

        if let image = self.image {

            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit

            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 128).isActive = true
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true

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
     * Called by the manager when the item was removed from the bulletin view.
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
