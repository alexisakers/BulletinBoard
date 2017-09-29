/**
 *  Bulletin
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * An object that manages the presentation of a bulletin.
 *
 * You create a bulletin manager by passing an array of `BulletinItem`s, that contains the data to display.
 *
 * The manager support displaying a sequence of mutiple items. When an item requests to display the
 * next or the previous item, the manager hides the contents of the current item, resizes the card if
 * needed and displays the new item.
 *
 * Use the `displayNextItem` function to request the next item ; and the `displayPreviousItem` function
 * to display the previous item.
 *
 * You must call the `prepare` function before displaying the view controller or changing the current
 * item.
 */

public final class BulletinManager: NSObject, UIViewControllerTransitioningDelegate {

    /// The view controller displaying the bulletin.
    private let viewController: BulletinViewController

    // MARK: - Private Properties

    private let items: [BulletinItem]
    private var currentItem: BulletinItem
    private var previousItem: BulletinItem?
    private var currentItemIndex: Int
    private var isPrepared: Bool = false
    private var isPreparing: Bool = true

    // MARK: - Initialization

    /**
     * Creates a bulletin manager with the list of items to display.
     *
     * An item represents the contents available on a single card.
     *
     * - parameter items: The items to display.
     */

    public init(items: [BulletinItem]) {

        precondition(items.count > 0, "You must provide at least one bulletin item to create a bulletin manager.")

        self.items = items
        self.currentItem = items[0]
        self.currentItemIndex = 0

        self.viewController = BulletinViewController()

    }

    // MARK: - Interacting with the Bulletin

    /**
     * Prepares the bulletin iterface and displays the first item.
     */

    public func prepare() {

        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        viewController.manager = self

        isPrepared = true
        isPreparing = true

        displayCurrentItem()
        isPreparing = false

    }

    /**
     * Displays the previous item in the sequence.
     *
     * If there is no previous item, nothing happens.
     */

    public func displayPreviousItem() {

        let previousIndex = currentItemIndex - 1

        guard previousIndex >= items.startIndex else {
            return
        }

        previousItem = items[currentItemIndex]

        currentItemIndex = previousIndex
        currentItem = items[currentItemIndex]

        displayCurrentItem()

    }

    /**
     * Displays the next item in the sequence.
     *
     * If there is no next item, nothing happens.
     */

    public func displayNextItem() {

        let nextIndex = currentItemIndex + 1

        guard nextIndex < items.endIndex else {
            return
        }

        previousItem = items[currentItemIndex]

        currentItemIndex = nextIndex
        currentItem = items[currentItemIndex]

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

        precondition(isPrepared, "You must call the `prepare` function before interacting with the bulletin.")
        presentingVC.present(viewController, animated: animated, completion: completion)

    }

    /**
     * Dismisses the bulletin and clears the current page.
     * - parameter animated: Whether to animate dismissal.
     */

    public func dismissBulletin( animated: Bool) {

        precondition(isPrepared, "You must call the `prepare` function before interacting with the bulletin.")

        currentItem.tearDown()
        currentItem.manager = nil

        viewController.dismiss(animated: true, completion: nil)
        viewController.manager = nil
        viewController.transitioningDelegate = nil

        currentItem = items[0]
        currentItemIndex = 0
        isPrepared = false

    }

    public func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {

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
            arrangedSubview.isHidden = true
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
