/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * An item that can be displayed inside a bulletin card.
 */

public protocol BulletinItem: class {

    // MARK: - Configuration

    /**
     * The current object managing the item.
     *
     * This property is set when the item is currently being displayed. It will be set to `nil` when
     * the item is removed from view.
     *
     * When implementing `BulletinItem`, you should make this property `weak` to avoid retain cycles.
     */

    var manager: BulletinManager? { get set }

    /**
     * Whether the page can be dismissed.
     *
     * If you set this value to `true`, the user will be able to dismiss the bulletin by tapping outside
     * the card.
     *
     * You should set it to `true` for the last item you want to display.
     */

    var isDismissable: Bool { get set }

    /**
     * The item to display after this one.
     *
     * If you set this value, you'll be able to call `displayNextItem()` to present the next item to
     * the stack.
     */

    var nextItem: BulletinItem? { get set }

    /**
     * Creates the list of views to display on the bulletin.
     *
     * The views will be arranged vertically in the order they are stored in the array.
     */

    func makeArrangedSubviews() -> [UIView]

    /**
     * Called by the manager when the item was removed from the bulletin view. Use this function
     * to remove any button target or gesture recognizers from your managed views.
     */

    func tearDown()

}

extension BulletinItem {

    /**
     * Displays the next item if it was set.
     */

    public func displayNextItem() {

        guard let nextItem = self.nextItem else {
            return
        }

        manager?.push(item: nextItem)

    }

}
