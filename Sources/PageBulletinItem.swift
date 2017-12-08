/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A standard bulletin item with a title and optional additional informations. It can display a large
 * action button and a smaller button for alternative options.
 *
 * - If you need to display custom elements with the standard buttons, subclass `PageBulletinItem` and
 * implement the `makeArrangedSubviews` method to return the elements to display above the buttons.
 *
 * You can also override this class to customize button tap handling. Override the `actionButtonTapped(sender:)`
 * and `alternativeButtonTapped(sender:)` methods to handle tap events. Make sure to call `super` in your
 * implementations if you do.
 *
 * Use the `appearance` property to customize the appearance of the page. If you want to use a different interface
 * builder type, change the `InterfaceBuilderType` property.
 */

@objc open class PageBulletinItem: ActionBulletinItem {

    // MARK: Initialization

    /**
     * Creates a bulletin page with the specified title.
     * - parameter title: The title of the page.
     */

    @objc public init(title: String) {
        self.title = title
    }

    @available(*, unavailable, message: "PageBulletinItem.init is unavailable. Use init(title:) instead.")
    override init() {
        fatalError("PageBulletinItem.init is unavailable. Use init(title:) instead.")
    }

    // MARK: - Page Contents

    /// The title of the page.
    @objc public let title: String

    /// An image to display below the title. It should have a size of 128 pixels by 128 pixels.
    @objc public var image: UIImage?
    
    /// An accessibility label which gets announced to VoiceOver users if the image gets focused.
    @objc public var imageAccessibilityLabel: String?

    /// A description text to display below the image.
    @objc public var descriptionText: String?

    // MARK: - Customization

    open func headerViews(_ interfaceBuilder: BulletinInterfaceBuilder) -> [UIView]? {
        return nil
    }

    open func viewsUnderTitle(_ interfaceBuilder: BulletinInterfaceBuilder) -> [UIView]? {
        return nil
    }

    open func viewsUnderImage(_ interfaceBuilder: BulletinInterfaceBuilder) -> [UIView]? {
        return nil
    }

    open func viewsUnderDescription(_ interfaceBuilder: BulletinInterfaceBuilder) -> [UIView]? {
        return nil
    }

    // MARK: - View Management

    @objc public private(set) var titleLabel: UILabel!
    @objc public private(set) var descriptionLabel: UILabel?
    @objc public private(set) var imageView: UIImageView?

    /**
     * Creates the content views of the page.
     *
     * You can override this method to customize the elements displayed above the buttons.
     */

    open override func makeContentViews(interfaceBuilder: BulletinInterfaceBuilder) -> [UIView] {

        var contentViews = [UIView]()

        func insertComplementaryViews(_ builder: (BulletinInterfaceBuilder) -> [UIView]?) {

            if let complementaryViews = builder(interfaceBuilder) {
                contentViews.append(contentsOf: complementaryViews)
            }

        }

        insertComplementaryViews(headerViews)

        // Title Label

        titleLabel = interfaceBuilder.makeTitleLabel(text: title)
        contentViews.append(titleLabel)

        insertComplementaryViews(viewsUnderTitle)

        // Image View

        if let image = self.image {

            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = appearance.imageViewTintColor

            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 128).isActive = true

            if let imageAccessibilityLabel = imageAccessibilityLabel {
                imageView.isAccessibilityElement = true
                imageView.accessibilityLabel = imageAccessibilityLabel
            }

            self.imageView = imageView
            contentViews.append(imageView)

        }

        insertComplementaryViews(viewsUnderImage)

        // Description Label

        if let descriptionText = self.descriptionText {

            descriptionLabel = interfaceBuilder.makeDescriptionLabel()
            descriptionLabel!.text = descriptionText
            contentViews.append(descriptionLabel!)

        }

        insertComplementaryViews(viewsUnderDescription)

        return contentViews

    }

}
