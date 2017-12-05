/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A standard bulletin item with that displays a large action button and a smaller button for alternative options.
 *
 * You do not use this class directly:
 *
 * - If you do not need to customize the elements displayed, use `PageBulletinItem`
 * which provides a title and description label, and and image view.
 * - If you need to display custom elements with the standard buttons, subclass `ActionBulletinItem` and
 * implement the `makeArrangedSubviews` method to return the elements to display above the buttons.
 *
 * You can also override this class to customize button tap handling. Override the `actionButtonTapped(sender:)`
 * and `alternativeButtonTapped(sender:)` methods to handle tap events. Make sure to call `super` in your
 * implementations if you do.
 *
 * Use the `appearance` property to customize the appearance of the buttons. If you want to use a different interface
 * builder type, change the `InterfaceBuilderType` property.
 */

@objc open class ActionBulletinItem: NSObject, BulletinItem {

    // MARK: - Page Contents

    /// The title of the action button.
    @objc public var actionButtonTitle: String?

    /// The title of the alternative button.
    @objc public var alternativeButtonTitle: String?


    // MARK: - BulletinItem

    /**
     * The object managing the item.
     *
     * This property is set when the item is currently being displayed. It will be set to `nil` when
     * the item is removed from bulletin.
     */

    @objc public weak var manager: BulletinManager?

    /**
     * Whether the page can be dismissed.
     *
     * If you set this value to `true`, the user will be able to dismiss the bulletin by tapping outside
     * of the card or by swiping down.
     *
     * You should set it to `true` for the last item you want to display.
     */

    @objc public var isDismissable: Bool = false

    /**
     * The block of code to execute when the bulletin item is dismissed. This is called when the bulletin
     * is moved out of view.
     *
     * You can leave it `nil` if `isDismissable` is set to false.
     *
     * - parameter item: The item that is being dismissed. When calling `dismissalHandler`, the manager
     * passes a reference to `self` so you don't have to manage weak references yourself.
     */

    @objc public var dismissalHandler: ((_ item: BulletinItem) -> Void)?

    /**
     * The item to display after this one.
     *
     * If you set this value, you'll be able to call `displayNextItem()` to push the next item to
     * the stack.
     */

    @objc public var nextItem: BulletinItem? = nil


    // MARK: - Customization

    /**
     * The appearance manager used to generate the interface of the page.
     *
     * Use this property to customize the appearance of the generated elements.
     *
     * Make sure to customize the appearance before presenting the page. Changing the appearance properties
     * after the bulletin page was presented has no effect.
     */

    @objc public var appearance = BulletinAppearance()

    /**
     * The type of interface builder to use to generate the components.
     *
     * Make sure to customize this property before presenting the page. Changing the interface builder type
     * after the bulletin page was presented has no effect.
     */

    @objc public var InterfaceBuilderType: BulletinInterfaceBuilder.Type = BulletinInterfaceBuilder.self

    // MARK: - Buttons

    fileprivate var actionButton: UIButton? = nil
    fileprivate var alternativeButton: UIButton? = nil

    /**
     * The code to execute when the action button is tapped.
     */

    @objc public var actionHandler: ((ActionBulletinItem) -> Void)? = nil

    /**
     * The code to execute when the alternative button is tapped.
     */

    @objc public var alternativeHandler: ((ActionBulletinItem) -> Void)? = nil

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
     * Creates the content views of the page.
     *
     * You override this method to customize the elements displayed above the buttons. The default
     * implementation returns an empty list of views.
     */

    open func makeContentViews(interfaceBuilder: BulletinInterfaceBuilder) -> [UIView] {
        return []
    }

    /**
     * Creates the list of views to display on the bulletin.
     *
     * This is an implementation detail of `BulletinItem` and you should not call it directly.
     */

    public func makeArrangedSubviews() -> [UIView] {

        var arrangedSubviews = [UIView]()
        let interfaceBuilder = InterfaceBuilderType.init(appearance: appearance)

        let contentViews = makeContentViews(interfaceBuilder: interfaceBuilder)
        arrangedSubviews.append(contentsOf: contentViews)

        // Buttons Stack

        if (actionButtonTitle == nil) && (alternativeButtonTitle == nil) {
            return arrangedSubviews
        }

        let buttonsStack = interfaceBuilder.makeGroupStack()

        if let actionButtonTitle = self.actionButtonTitle {

            let actionButton = interfaceBuilder.makeActionButton(title: actionButtonTitle)
            buttonsStack.addArrangedSubview(actionButton)
            actionButton.button.addTarget(self, action: #selector(actionButtonTapped(sender:)), for: .touchUpInside)

            self.actionButton = actionButton.button

        }

        if let alternativeButtonTitle = self.alternativeButtonTitle {

            let alternativeButton = interfaceBuilder.makeAlternativeButton(title: alternativeButtonTitle)
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
     * Override this method if elements you returned in `makeContentViews` need cleanup. Make sure
     * to call `super` if you override this method.
     *
     * This is an implementation detail of `BulletinItem` and you should not call it directly.
     */

    open func tearDown() {
        actionButton?.removeTarget(self, action: nil, for: .touchUpInside)
        alternativeButton?.removeTarget(self, action: nil, for: .touchUpInside)
        actionButton = nil
        alternativeButton = nil
    }

}
