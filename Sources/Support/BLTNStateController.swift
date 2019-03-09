/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import Foundation

protocol BLTNStateControllerDelegate: class {
    func stateController(_ controller: BLTNStateController, didUpdateCurrentItem currentItem: BLTNItem, previousItem: BLTNItem?)
}

class BLTNStateController {

    var currentItem: BLTNItem

    var rootItem: BLTNItem
    var itemsStack: [BLTNItem]

    var previousItem: BLTNItem? {
        didSet {
            oldValue?.tearDown()
            oldValue?.parent = nil
        }
    }

    /// Whether we need to display a close button for the current item.
    var needsCloseButton: Bool {
        return currentItem.isDismissable && currentItem.showsCloseButton
    }

    weak var delegate: BLTNStateControllerDelegate?

    init(rootItem: BLTNItem) {
        self.rootItem = rootItem
        self.currentItem = rootItem
        self.itemsStack = [rootItem]
    }

    deinit {
        tearDownItemsChain(startingAt: self.rootItem)

        for item in itemsStack {
            tearDownItemsChain(startingAt: item)
        }
    }


    /// Displays a new item after the current one.
    func push(item: BLTNItem) {
        previousItem = currentItem
        itemsStack.append(item)
        currentItem = item
        delegate?.stateController(self, didUpdateCurrentItem: currentItem, previousItem: previousItem)
    }

    /// Removes the current item from the stack and displays the previous item.
    func popItem() {
        guard let previousItem = itemsStack.popLast() else {
            return popToRootItem()
        }

        self.previousItem = previousItem

        guard let currentItem = itemsStack.last else {
            return popToRootItem()
        }

        self.currentItem = currentItem
        delegate?.stateController(self, didUpdateCurrentItem: currentItem, previousItem: previousItem)
    }

    /// Removes all the items from the stack and displays the root item.
    func popToRootItem() {
        previousItem = currentItem === rootItem ? nil : currentItem
        itemsStack = []
        currentItem = rootItem
        delegate?.stateController(self, didUpdateCurrentItem: currentItem, previousItem: previousItem)
    }

    /**
     * Displays the next item, if the `next` property of the current item is set.
     * - warning: If you call this method but `next` is `nil`, an exception will be raised.
     */

    func displayNextItem() {
        guard let next = currentItem.next else {
            thank_u_next()
        }

        push(item: next)
    }

    /// Resets the state of the bulletin for reuse.
    func reset() {
        currentItem.didDismiss()
        currentItem = rootItem
        itemsStack.removeAll()
    }

    private func thank_u_next() -> Never {
        preconditionFailure("Calling displayNextItem, but the current item has no nextItem.")
    }

    /// Tears down every item on the stack starting from the specified item.
    fileprivate func tearDownItemsChain(startingAt item: BLTNItem) {
        item.tearDown()
        item.parent = nil

        if let next = item.next {
            tearDownItemsChain(startingAt: next)
            item.next = nil
        }
    }

}
