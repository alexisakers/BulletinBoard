/**
*  BulletinBoard
*  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
*/

import UIKit

/**
* A standard bulletin item with a title and optional additional informations. It can display a large
* action button and a smaller button for alternative options.
*
* - If you need to display custom elements with the standard buttons, subclass `BLTNPageItem` and
* implement the `makeArrangedSubviews` method to return the elements to display above the buttons.
*
* You can also override this class to customize button tap handling. Override the `actionButtonTapped(sender:)`
* and `alternativeButtonTapped(sender:)` methods to handle tap events. Make sure to call `super` in your
* implementations if you do.
*
* Use the `appearance` property to customize the appearance of the page. If you want to use a different interface
* builder type, change the `interfaceBuilderType` property.
*/

@objc open class BLTNPageItem: BLTNActionItem {
    
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

    @objc open var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }

    /// An accessibility label which gets announced to VoiceOver users if the image gets focused.
    @objc open var imageAccessibilityLabel: String? {
        didSet {
            image?.accessibilityLabel = imageAccessibilityLabel
        }
    }

    /**
     * An description text to display below the image.
     *
     * If you set this property to `nil`, no label will be displayed (this is the default).
     */

    @objc open var descriptionText: String? {
        didSet {
            descriptionLabel?.text = descriptionText
        }
    }

    /**
     * An attributed description text to display below the image.
     *
     * If you set this property to `nil`, no label will be displayed (this is the default). The attributed
     * text takes priority over the regular description label. If you set both values, only the
     * `attributedDescriptionText` will be used.
     */

    @objc open var attributedDescriptionText: NSAttributedString? {
        didSet {
            descriptionLabel?.attributedText = attributedDescriptionText
        }
    }

    // MARK: - View Management

    @objc private(set) open var titleLabel: BLTNTitleLabelContainer?
    @objc private(set) open var descriptionLabel: UILabel?
    @objc private(set) open var imageView: UIImageView?

    // MARK: - Initialization
    
    /**
     * Creates a bulletin page with the specified title.
     * - parameter title: The title of the page.
     */
    
    @objc public init(title: String) {
        self.title = title
        super.init()
    }

    
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

    @objc(makeHeaderViewsWithInterfaceBuilder:)
    open func makeHeaderViews(interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
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

    @objc(makeViewsUnderTitleWithInterfaceBuilder:)
    open func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
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

    @objc(makeViewsUnderImageWithInterfaceBuilder:)
    open func makeViewsUnderImage(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
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

    @objc(makeViewsUnderDescriptionWithInterfaceBuilder:)
    open func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        return nil
    }

    // MARK: - Overrides
    
    open override func makeContentViews(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView] {
        var contentViews: [UIView] = []
        
        func insertComplementaryViews(_ builder: (BLTNInterfaceBuilder) -> [UIView]?) {
            if let complementaryViews = builder(interfaceBuilder) {
                contentViews += complementaryViews
            }
        }
        
        // Headers
        insertComplementaryViews(makeHeaderViews)
        
        // Title
        let isNextToCloseButton = isDismissable && requiresCloseButton
        let titleView = interfaceBuilder.makeTitleLabel(isNextToCloseButton: isNextToCloseButton)
        titleView.label.text = title
        
        self.titleLabel = titleView
        contentViews.append(titleView)
        insertComplementaryViews(makeViewsUnderTitle)
        
        // Image View
        if let image = self.image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = appearance.imageViewTintColor
            
            if let accessibilityLabel = imageAccessibilityLabel {
                imageView.isAccessibilityElement = true
                imageView.accessibilityLabel = accessibilityLabel
            } else {
                imageView.isAccessibilityElement = false
            }
            
            self.imageView = imageView
            contentViews.append(imageView)
            insertComplementaryViews(makeViewsUnderImage)
        }
        
        // Description Label
        if let attributedDescription = attributedDescriptionText {
            let label = interfaceBuilder.makeDescriptionLabel()
            label.attributedText = attributedDescription
            contentViews.append(label)
            self.descriptionLabel = label
            insertComplementaryViews(makeViewsUnderDescription)
        } else if let description = descriptionText {
            let label = interfaceBuilder.makeDescriptionLabel()
            label.text = description
            contentViews.append(label)
            self.descriptionLabel = label
            insertComplementaryViews(makeViewsUnderDescription)
        }
        
        return contentViews
    }
}
