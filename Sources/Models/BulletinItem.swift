/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * An item that can be displayed inside a bulletin card.
 */

@objc public protocol BulletinItem: class {

    // MARK: - Configuration

    /**
     * The current object managing the item.
     *
     * This property is set when the item is currently being displayed. It will be set to `nil` when
     * the item is removed from view.
     *
     * When implementing `BulletinItem`, you should mark this property `weak` to avoid retain cycles.
     */

    var manager: BulletinManager? { get set }

    /**
     * Whether the page can be dismissed.
     *
     * If you set this value to `true`, the user will be able to dismiss the bulletin by tapping outside
     * of the card or by swiping down.
     *
     * You should set it to `true` for the last item you want to display, or for items that start an optional flow
     * (ex: a purchase).
     */

    var isDismissable: Bool { get set }

    /**
     * Whether the item should move with the keyboard.
     *
     * You must set it to `true` if the item displays a text field. Otherwise, you can set it to `false` if you
     * don't want the bulletin to move when system alerts are displayed.
     */

    var shouldRespondToKeyboardChanges: Bool { get set }

    /**
     * The block of code to execute when the bulletin item is dismissed. This is called after the bulletin
     * is moved out of view.
     *
     * - parameter item: The item that is being dismissed.

     * When calling `dismissalHandler`, the manager passes a reference to `self` so you don't have to retain a
     * weak reference yourself.
     */

    var dismissalHandler: ((_ item: BulletinItem) -> Void)? { get set }

    /**
     * The item to display after this one.
     *
     * If you set this value, you'll be able to call `manager?.displayNextItem()` to push the next item to
     * the stack.
     */

    var nextItem: BulletinItem? { get set }

    // MARK: - Interface

    /**
     * Creates the list of views to display inside the bulletin card.
     *
     * The views will be arranged vertically, in the order they are stored in the return array.
     */

    func makeArrangedSubviews() -> [UIView]

    /**
     * Called by the manager when the item was removed from the bulletin.
     *
     * Use this function to remove any button target or gesture recognizers from your managed views, and
     * deallocate any resources created for this item that are no longer needed.
     */

    func tearDown()

}
