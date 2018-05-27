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

    /**
     * An image to display below the title.
     *
     * If you set this property to `nil`, no image will be displayed (this is the default).
     *
     * The image should have a size of 128x128 pixels (@1x).
     */

    @objc public var image: UIImage?

    /// An accessibility label which gets announced to VoiceOver users if the image gets focused.
    @objc public var imageAccessibilityLabel: String?

    /**
     * An description text to display below the image.
     *
     * If you set this property to `nil`, no label will be displayed unless the `attributedDescriptionText` is set (this is the default).
     */

    @objc public var descriptionText: String?

    /**
     * An attributed description text to display below the image.
     *
     * If you set this property to `nil`, no label will be displayed unless the `descriptionText` is set (this is the default).
     */

    @objc public var attributedDescriptionText: NSAttributedString?

    // MARK: - Customization

    /**
     * The views to display above the title.
     *
     * You can override this method to insert custom views before the title. The default implementation returns `nil` and
     * does not append header elements.
     *
     * This method is called inside `makeArrangedSubviews` before the title is created.
     *
     * - parameter interfaceBuilder: The interface builder used to create the title.
     * - returns: The header views for the item, or `nil` if no header views should be added.
     */

    open func headerViews(_ interfaceBuilder: BulletinInterfaceBuilder) -> [UIView]? {
        return nil
    }

    /**
     * The views to display below the title.
     *
     * You can override this method to insert custom views after the title. The default implementation returns `nil` and
     * does not append elements after the title.
     *
     * This method is called inside `makeArrangedSubviews` after the title is created.
     *
     * - parameter interfaceBuilder: The interface builder used to create the title.
     * - returns: The views to display after the title, or `nil` if no views should be added.
     */

    open func viewsUnderTitle(_ interfaceBuilder: BulletinInterfaceBuilder) -> [UIView]? {
        return nil
    }

    /**
     * The views to display below the image.
     *
     * You can override this method to insert custom views after the image. The default implementation returns `nil` and
     * does not append elements after the image.
     *
     * This method is called inside `makeArrangedSubviews` after the image is created.
     *
     * - parameter interfaceBuilder: The interface builder used to create the image.
     * - returns: The views to display after the image, or `nil` if no views should be added.
     */

    open func viewsUnderImage(_ interfaceBuilder: BulletinInterfaceBuilder) -> [UIView]? {
        return nil
    }

    /**
     * The views to display below the description.
     *
     * You can override this method to insert custom views after the description. The default implementation
     * returns `nil` and does not append elements after the description.
     *
     * This method is called inside `makeArrangedSubviews` after the description is created.
     *
     * - parameter interfaceBuilder: The interface builder used to create the description.
     * - returns: The views to display after the description, or `nil` if no views should be added.
     */

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
     * It creates the standard elements and appends the additional customized elements returned by the
     * `viewsUnder` hooks.
     */

    public final override func makeContentViews(interfaceBuilder: BulletinInterfaceBuilder) -> [UIView] {

        var contentViews = [UIView]()

        func insertComplementaryViews(_ builder: (BulletinInterfaceBuilder) -> [UIView]?) {

            if let complementaryViews = builder(interfaceBuilder) {
                contentViews.append(contentsOf: complementaryViews)
            }

        }

        insertComplementaryViews(headerViews)

        // Title Label

        titleLabel = interfaceBuilder.makeTitleLabel()
        titleLabel.text = title

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


        if let attributedDescriptionText = self.attributedDescriptionText {

            descriptionLabel = interfaceBuilder.makeDescriptionLabel()
            descriptionLabel!.attributedText = attributedDescriptionText
            contentViews.append(descriptionLabel!)

        } else if let descriptionText = self.descriptionText {

            descriptionLabel = interfaceBuilder.makeDescriptionLabel()
            descriptionLabel!.text = descriptionText
            contentViews.append(descriptionLabel!)

        }

        insertComplementaryViews(viewsUnderDescription)

        return contentViews

    }

}
