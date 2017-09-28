/**
 *  Bulletin
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A standard bulletin item with a title and optional additional informations.
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

    /// An image to display below the title. Should be 128x128px.
    public var image: UIImage?

    /// A description text to display below the image.
    public var descriptionText: String?

    /// The title of the action button.
    public var actionButtonTitle: String?

    /// The title of the ignore button.
    public var ignoreButtonTitle: String?


    // MARK: - Behavior

    public var manager: BulletinManager? = nil
    public var isDismissable: Bool = false

    /**
     * Whether the description text is long. If `true`, the text will be displayed with a smaller font.
     */

    public var isLongDescriptionText: Bool = false


    // MARK: - Buttons

    fileprivate var actionButton: ContainerView<HighlightButton>? = nil
    fileprivate var ignoreButton: UIButton? = nil

    /**
     * The code to execute when the action button is pressed.
     */

    public var actionHandler: ((PageBulletinItem) -> Void)? = nil

    /**
     * The code to execute when the ignore button is pressed.
     */

    public var ignoreHandler: ((PageBulletinItem) -> Void)? = nil

    /**
     * Handles a tap on the action button.
     */

    @objc open func actionButtonTapped(sender: UIButton) {
        actionHandler?(self)
    }

    /**
     * Handles a tap on the ignore button.
     */

    @objc open func ignoreButtonTapped(sender: UIButton) {
        ignoreHandler?(self)
    }


    // MARK: - View Management

    open func tearDown() {
        actionButton?.contentView.removeTarget(self, action: nil, for: .touchUpInside)
        ignoreButton?.removeTarget(self, action: nil, for: .touchUpInside)
    }

    open func makeArrangedSubviews() -> [UIView] {

        var arrangedSubviews = [UIView]()

        // Title Label

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.568627451, green: 0.5647058824, blue: 0.5725490196, alpha: 1)
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center

        arrangedSubviews.append(titleLabel)

        // Image View

        if let image = self.image {

            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true

            arrangedSubviews.append(imageView)

        }

        // Description Label

        if let descriptionText = self.descriptionText {

            let descriptionLabel = UILabel()
            descriptionLabel.text = descriptionText
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textAlignment = .center

            let fontSize: CGFloat = isLongDescriptionText ? 15 : 20
            descriptionLabel.font = UIFont.systemFont(ofSize: fontSize)

            arrangedSubviews.append(descriptionLabel)

        }

        // Buttons Stack

        let buttonsStack = UIStackView()
        buttonsStack.axis = .vertical
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fill
        buttonsStack.spacing = 10

        buttonsStack.isHidden = true

        actionButton = makeActionButton()
        ignoreButton = makeIgnoreButton()

        if let actionButton = self.actionButton {
            buttonsStack.addArrangedSubview(actionButton)
            actionButton.contentView.addTarget(self, action: #selector(actionButtonTapped(sender:)), for: .touchUpInside)
        }

        if let ignoreButton = self.ignoreButton {
            buttonsStack.addArrangedSubview(ignoreButton)
            ignoreButton.addTarget(self, action: #selector(ignoreButtonTapped(sender:)), for: .touchUpInside)
        }

        arrangedSubviews.append(buttonsStack)

        return arrangedSubviews

    }

    open func makeActionButton() -> ContainerView<HighlightButton>? {

        guard let actionButtonTitle = self.actionButtonTitle else {
            return nil
        }

        let actionButton = HighlightButton(type: .custom)
        actionButton.setTitle(actionButtonTitle, for: .normal)
        actionButton.setBackgroundColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), forState: .normal)
        actionButton.contentHorizontalAlignment = .fill
        actionButton.layer.cornerRadius = 12
        actionButton.clipsToBounds = true
        actionButton.contentHorizontalAlignment = .center
        actionButton.autoresizingMask = .flexibleWidth
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        let actionContainer = ContainerView<HighlightButton>(actionButton)
        actionContainer.heightAnchor.constraint(equalToConstant: 55).isActive = true

        return actionContainer

    }

    open func makeIgnoreButton() -> UIButton? {

        guard let ignoreButtonTitle = self.ignoreButtonTitle else {
            return nil
        }

        let ignoreButton = UIButton(type: .system)
        ignoreButton.setTitle(ignoreButtonTitle, for: .normal)
        ignoreButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)

        return ignoreButton

    }

}
