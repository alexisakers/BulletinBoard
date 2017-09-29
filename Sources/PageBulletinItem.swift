/**
 *  Bulletin
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

    /**
     * The interface factory used to generate the interface of the page.
     *
     * Use this property to customize the appearance of buttons.
     */

    public let interfaceFactory = BulletinInterfaceFactory()

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

    /// An image to display below the title. Should be 128x128px.
    public var image: UIImage?

    /// A description text to display below the image.
    public var descriptionText: String?

    /// The title of the action button.
    public var actionButtonTitle: String?

    /// The title of the alternative button.
    public var alternativeButtonTitle: String?


    // MARK: - Behavior

    public weak var manager: BulletinManager? = nil
    public var isDismissable: Bool = false
    public var nextItem: BulletinItem? = nil

    /**
     * Whether the description text is long. If `true`, the text will be displayed with a smaller font.
     */

    public var isLongDescriptionText: Bool = false


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

    public func tearDown() {
        actionButton?.contentView.removeTarget(self, action: nil, for: .touchUpInside)
        alternativeButton?.removeTarget(self, action: nil, for: .touchUpInside)
    }

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
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true

            arrangedSubviews.append(imageView)

        }

        // Description Label

        if let descriptionText = self.descriptionText {

            let descriptionLabel = interfaceFactory.makeDescriptionLabel(isCompact: isLongDescriptionText)
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

}
