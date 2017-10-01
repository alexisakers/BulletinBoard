/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * An item that can be displayed inside a bulletin card.
 */

public protocol BulletinItem: class {

    /// The current object managing the item.
    var manager: BulletinManager? { get set }

    /// Whether the page can be dismissed.
    var isDismissable: Bool { get set }

    /// The item to display after this one.
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
