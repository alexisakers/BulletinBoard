/**
 *  Bulletin
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * An object that manages the presentation of a bulletin.
 *
 * You create a bulletin manager by passing a root `BulletinItem`s, that contains the data to display.
 *
 * The manager works similar to a navigation controller. You can push new items to display them and
 * pop existing ones to go back.
 *
 * You must call the `prepare` function before displaying the view controller or changing the current
 * item.
 *
 * `BulletinManager` must be used on the main thread only.
 */

public final class BulletinManager: NSObject, UIViewControllerTransitioningDelegate {

    /// The view controller displaying the bulletin.
    private let viewController: BulletinViewController

    // MARK: - Private Properties

    private let rootItem: BulletinItem

    private var itemsStack: [BulletinItem]
    private var currentItem: BulletinItem
    private var previousItem: BulletinItem?

    private var isPrepared: Bool = false
    private var isPreparing: Bool = false

    // MARK: - Initialization

    /**
     * Creates a bulletin manager with the list of items to display.
     *
     * An item represents the contents available on a single card.
     *
     * - parameter items: The items to display.
     */

    public init(rootItem: BulletinItem) {

        self.rootItem = rootItem
        self.itemsStack = []
        self.currentItem = rootItem

        self.viewController = BulletinViewController()

    }

    // MARK: - Interacting with the Bulletin

    /**
     * Prepares the bulletin iterface and displays the root item.
     */

    public func prepare() {

        precondition(Thread.isMainThread)

        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        viewController.manager = self

        isPrepared = true
        isPreparing = true

        displayCurrentItem()
        isPreparing = false

    }

    /**
     * Displays a new item after the current one.
     * - parameter item: The item to display.
     */

    public func push(item: BulletinItem) {

        precondition(Thread.isMainThread)

        previousItem = currentItem
        itemsStack.append(item)

        currentItem = item
        displayCurrentItem()

    }

    /**
     * Removes the current item from the stack and displays the previous item.
     */

    public func popItem() {

        precondition(Thread.isMainThread)

        guard let previousItem = itemsStack.popLast() else {
            popToRootItem()
            return
        }

        self.previousItem = previousItem

        guard let currentItem = itemsStack.last else {
            popToRootItem()
            return
        }

        self.currentItem = currentItem
        displayCurrentItem()

    }

    /**
     * Removes all the items from the stack and displays the root item.
     */

    public func popToRootItem() {

        precondition(Thread.isMainThread)

        guard currentItem !== rootItem else {
            return
        }

        previousItem = currentItem
        currentItem = rootItem

        itemsStack = []

        displayCurrentItem()

    }

    // MARK: - Presentation / Dismissal

    /**
     * Presents the bulletin above the specified view controller.
     *
     * - parameter presentingVC: The view controller to use to present the bulletin.
     * - parameter animated: Whether to animate presentation. Defaults to `true`.
     * - parameter completion: An optional block to execute after presentation. Default to `nil`.
     */

    public func presentBulletin(above presentingVC: UIViewController,
                                animated: Bool = true,
                                completion: (() -> Void)? = nil) {

        precondition(Thread.isMainThread)

        precondition(isPrepared, "You must call the `prepare` function before interacting with the bulletin.")
        presentingVC.present(viewController, animated: animated, completion: completion)

    }

    /**
     * Dismisses the bulletin and clears the current page.
     * - parameter animated: Whether to animate dismissal.
     */

    public func dismissBulletin( animated: Bool) {

        precondition(Thread.isMainThread)
        precondition(isPrepared, "You must call the `prepare` function before interacting with the bulletin.")

        currentItem.tearDown()
        currentItem.manager = nil

        viewController.dismiss(animated: true, completion: nil)
        viewController.manager = nil
        viewController.transitioningDelegate = nil

        currentItem = rootItem
        isPrepared = false

    }

    public func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {

        precondition(Thread.isMainThread)

        if presented is BulletinViewController {
            return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
        }

        return nil

    }

    // MARK: - Management

    private func displayCurrentItem() {

        precondition(isPrepared, "You must call the `prepare` function before interacting with the bulletin.")
        viewController.isDismissable = false

        // Tear down old item

        let oldArrangedSubviews = viewController.contentStackView.arrangedSubviews

        previousItem?.tearDown()
        previousItem?.manager = nil
        previousItem = nil

        currentItem.manager = self

        // Create new views

        let newArrangedSubviews = currentItem.makeArrangedSubviews()

        for arrangedSubview in newArrangedSubviews {
            arrangedSubview.isHidden = isPreparing ? false : true
            viewController.contentStackView.addArrangedSubview(arrangedSubview)
        }

        // Animate transition

        let animationDurationFactor: Double = isPreparing ? 0 : 1

        let initialAlphaAnimationDuration = 0.25 * animationDurationFactor

        let initialAlphaAnimations = {

            for arrangedSubview in oldArrangedSubviews {
                arrangedSubview.alpha = 0
            }

            for arrangedSubview in newArrangedSubviews {
                arrangedSubview.alpha = 0
            }

        }

        let transitionAnimationDuration = 0.25 * animationDurationFactor

        let transitionAnimation = {

            for arrangedSubview in oldArrangedSubviews {
                arrangedSubview.isHidden = true
            }

            for arrangedSubview in newArrangedSubviews {
                arrangedSubview.isHidden = false
            }

        }

        let finalAlphaAnimationDuration = 0.25 * animationDurationFactor

        let finalAlphaAnimation = {

            for arrangedSubview in newArrangedSubviews {
                arrangedSubview.alpha = 1
            }

        }

        UIView.animate(withDuration: initialAlphaAnimationDuration, animations: initialAlphaAnimations) { _ in

            UIView.animate(withDuration: transitionAnimationDuration, animations: transitionAnimation) { _ in

                UIView.animate(withDuration: finalAlphaAnimationDuration, animations: finalAlphaAnimation) { _ in

                    self.viewController.isDismissable = self.currentItem.isDismissable

                    for arrangedSubview in oldArrangedSubviews {
                        self.viewController.contentStackView.removeArrangedSubview(arrangedSubview)
                    }

                }

            }

        }

    }

}
