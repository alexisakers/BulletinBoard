/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * An object that manages the presentation of a bulletin.
 *
 * You create a bulletin manager using the `init(rootItem:)` initializer, where `rootItem` is the
 * first bulletin item to display. An item represents the contents displayed on a single card.
 *
 * The manager works like a navigation controller. You can push new items to the stack to display them,
 * and pop existing ones to go back.
 *
 * You must call the `prepare` method before displaying the view controller.
 *
 * `BLTNItemManager` must only be used from the main thread.
 */

@objc public final class BLTNItemManager: NSObject {

    /// Bulletin view controller.
    fileprivate var bulletinController: BulletinViewController!

    // MARK: - Background

    /**
     * The background color of the bulletin card. Defaults to white.
     *
     * Set this value before presenting the bulletin. Changing it after will have no effect.
     */

    @objc public var backgroundColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    /**
     * The style of the view covering the content. Defaults to `.dimmed`.
     *
     * Set this value before presenting the bulletin. Changing it after will have no effect.
     */

    @objc public var backgroundViewStyle: BLTNBackgroundViewStyle = .dimmed

    // MARK: - Status Bar

    /**
     * The style of status bar to use with the bulltin. Defaults to `.automatic`.
     *
     * Set this value before presenting the bulletin. Changing it after will have no effect.
     */

    @objc public var statusBarAppearance: BLTNStatusBarAppearance = .automatic

    /**
     * The style of status bar animation. Defaults to `.fade`.
     *
     * Set this value before presenting the bulletin. Changing it after will have no effect.
     */

    @objc public var statusBarAnimation: UIStatusBarAnimation = .fade

    /**
     * The home indicator for iPhone X should be hidden or not. Defaults to false.
     *
     * Set this value before presenting the bulletin. Changing it after will have no effect.
     */

    @objc public var hidesHomeIndicator: Bool = false

    // MARK: - Card Presentation

    /**
     * The spacing between the edge of the screen and the edge of the card. Defaults to regular.
     *
     * Set this value before presenting the bulletin. Changing it after will have no effect.
     */

    @objc public var edgeSpacing: BLTNSpacing = .regular

    /**
     * The rounded corner radius of the bulletin card. Defaults to 12, and 36 on iPhone X.
     *
     * Set this value before calling `prepare`. Changing it after will have no effect.
     */

    @objc public var cardCornerRadius: NSNumber?

    /**
     * Whether swipe to dismiss should be allowed. Defaults to true.
     *
     * If you set this value to true, the user will be able to drag the card, and swipe down to
     * dismiss it (if allowed by the current item).
     *
     * If you set this value to false, no pan gesture will be recognized, and swipe to dismiss
     * won't be available.
     */

    @objc public var allowsSwipeInteraction: Bool = true
    
    /**
     * Tells us if a bulletin is currently being shown. Defaults to false
     */

    @objc public var isShowingBulletin: Bool { 
        return bulletinController?.presentingViewController != nil
    }

    // MARK: - Private Properties

    var currentItem: BLTNItem

    fileprivate let rootItem: BLTNItem
    fileprivate var itemsStack: [BLTNItem]
    fileprivate var previousItem: BLTNItem?
    fileprivate var presentingWindow: UIWindow?

    fileprivate var isPrepared: Bool = false
    fileprivate var isPreparing: Bool = false
    fileprivate var shouldDisplayActivityIndicator: Bool = false
    fileprivate var lastActivityIndicatorColor: UIColor = .black

    // MARK: - Initialization

    /**
     * Creates a bulletin manager and sets the first item to display.s
     *
     * - parameter rootItem: The first item to display.
     */

    @objc public init(rootItem: BLTNItem) {

        self.rootItem = rootItem
        self.itemsStack = []
        self.currentItem = rootItem

    }

    deinit {

        tearDownItemsChain(startingAt: self.rootItem)

        for item in itemsStack {
            tearDownItemsChain(startingAt: item)
        }

    }

    @available(*, unavailable, message: "Use init(rootItem:) instead.")
    override init() {
        fatalError("BLTNItemManager.init is unavailable. Use init(rootItem:) instead.")
    }

}

// MARK: - Interacting with the Bulletin

extension BLTNItemManager {

    /**
     * Prepares the bulletin interface and displays the root item.
     *
     * This method must be called before any other interaction with the bulletin.
     */

    fileprivate func prepare() {

        assertIsMainThread()

        bulletinController = BulletinViewController()
        bulletinController.manager = self

        bulletinController.modalPresentationStyle = .overFullScreen
        bulletinController.transitioningDelegate = bulletinController
        bulletinController.loadBackgroundView()
        bulletinController.setNeedsStatusBarAppearanceUpdate()

        if #available(iOS 11.0, *) {
            bulletinController.setNeedsUpdateOfHomeIndicatorAutoHidden()
        }

        isPrepared = true
        isPreparing = true
        shouldDisplayActivityIndicator = rootItem.shouldStartWithActivityIndicator

        refreshCurrentItemInterface()
        isPreparing = false

    }

    /**
     * Presents a view controller above the bulletin card.
     *
     * This is useful if you want to present an alert or a Safari view contoller in response to user
     * action.
     *
     * - parameter viewController: The view controller to present.
     * - parameter animated: Whether presentation should be animated.
     * - parameter completion: An optional completion block to run after presentation
     * has completed. Defaults to `nil`.
     */

    @objc(presentViewControllerAboveBulletin:animated:completion:)
    public func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        assertIsPrepared()
        self.bulletinController.present(viewController, animated: animated, completion: completion)
    }

    /**
     * Performs an operation with the bulletin content view and returns the result.
     *
     * Use this as an opportunity to customize the behavior of the content view (e.g. add motion effects).
     *
     * You must not store a reference to the view, or modify its layout (add subviews, add contraints, ...) as this
     * could break the bulletin.
     *
     * Use this feature sparingly.
     *
     * - parameter transform: The code to execute with the content view.
     * - warning: If you save the content view outside of the `transform` closure, an exception will be raised.
     */

    @discardableResult
    public func withContentView<Result>(_ transform: (UIView) throws -> Result) rethrows -> Result {

        assertIsPrepared()
        assertIsMainThread()

        let contentView = bulletinController.contentView
        let initialRetainCount = CFGetRetainCount(contentView)

        let result = try transform(bulletinController.contentView)
        let finalRetainCount = CFGetRetainCount(contentView)

        precondition(initialRetainCount == finalRetainCount,
                     "The content view was saved outside of the transform closure. This is not allowed.")

        return result

    }

    /**
     * Hides the contents of the stack and displays an activity indicator view.
     *
     * Use this method if you need to perform a long task or fetch some data before changing the item.
     *
     * Displaying the loading indicator does not change the height of the page or the current item. It will disable
     * dismissal by tapping and swiping to allow the task to complete and avoid resource deallocation.
     *
     * - parameter color: The color of the activity indicator to display. Defaults to black.
     *
     * Displaying the loading indicator does not change the height of the page or the current item.
     */

    @objc public func displayActivityIndicator(color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) {

        assertIsPrepared()
        assertIsMainThread()

        shouldDisplayActivityIndicator = true
        lastActivityIndicatorColor = color

        bulletinController.displayActivityIndicator(color: color)

    }

    /**
     * Hides the activity indicator and displays the current item.
     *
     * You can also call one of `popItem`, `popToRootItem` and `pushItem` if you need to hide the activity
     * indicator and change the current item.
     */

    @objc public func hideActivityIndicator() {

        assertIsPrepared()
        assertIsMainThread()

        shouldDisplayActivityIndicator = false
        bulletinController.swipeInteractionController?.cancelIfNeeded()
        refreshCurrentItemInterface(elementsChanged: false)

    }

    /**
     * Displays a new item after the current one.
     * - parameter item: The item to display.
     */

    @objc public func push(item: BLTNItem) {

        assertIsPrepared()
        assertIsMainThread()

        previousItem = currentItem
        itemsStack.append(item)

        currentItem = item

        shouldDisplayActivityIndicator = item.shouldStartWithActivityIndicator
        refreshCurrentItemInterface()

    }

    /**
     * Removes the current item from the stack and displays the previous item.
     */

    @objc public func popItem() {

        assertIsPrepared()
        assertIsMainThread()

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

        shouldDisplayActivityIndicator = currentItem.shouldStartWithActivityIndicator
        refreshCurrentItemInterface()

    }

    /**
     * Removes all the items from the stack and displays the root item.
     */

    @objc public func popToRootItem() {

        assertIsPrepared()
        assertIsMainThread()

        guard currentItem !== rootItem else {
            return
        }

        previousItem = currentItem
        currentItem = rootItem

        itemsStack = []

        shouldDisplayActivityIndicator = rootItem.shouldStartWithActivityIndicator
        refreshCurrentItemInterface()

    }

    /**
     * Displays the next item, if the `next` property of the current item is set.
     *
     * - warning: If you call this method but `next` is `nil`, an exception will be raised.
     */

    @objc public func displayNextItem() {

        guard let next = currentItem.next else {
            preconditionFailure("Calling BLTNItemManager.displayNextItem, but the current item has no nextItem.")
        }

        push(item: next)

    }

}

// MARK: - Presentation / Dismissal

extension BLTNItemManager {

    /**
     * Presents the bulletin above the specified view controller.
     *
     * - parameter presentingVC: The view controller to use to present the bulletin.
     * - parameter animated: Whether to animate presentation. Defaults to `true`.
     * - parameter completion: An optional block to execute after presentation. Default to `nil`.
     */

    @objc(showBulletinAboveViewController:animated:completion:)
    public func showBulletin(above presentingVC: UIViewController,
                                       animated: Bool = true,
                                     completion: (() -> Void)? = nil) {

        self.prepare()

        let isDetached = bulletinController.presentingViewController == nil
        assert(isDetached, "Attempt to present a Bulletin that is already presented.")

        assertIsPrepared()
        assertIsMainThread()
        bulletinController.loadView()

        let refreshActivityIndicator = shouldDisplayActivityIndicator && isDetached

        if refreshActivityIndicator {
            bulletinController.displayActivityIndicator(color: lastActivityIndicatorColor)
        }

        bulletinController.modalPresentationCapturesStatusBarAppearance = true
        presentingVC.present(bulletinController, animated: animated, completion: completion)

    }
    
    /**
     * Presents the bulletin on top of your application window.
     *
     * - parameter application: The application in which to display the bulletin. (normally: UIApplication.shared)
     * - parameter animated: Whether to animate presentation. Defaults to `true`.
     * - parameter completion: An optional block to execute after presentation. Default to `nil`.
     */
    
    @objc(showBulletinInApplication:animated:completion:)
    public func showBulletin(in application: UIApplication,
                             animated: Bool = true,
                             completion: (() -> Void)? = nil) {
        assert(presentingWindow == nil, "Attempt to present a Bulletin on top of another Bulletin window. Make sure to dismiss any existing bulletin before calling this method.")
        presentingWindow = UIWindow(frame: UIScreen.main.bounds)
        presentingWindow?.rootViewController = UIViewController()
        
        // set alert window above current top window
        if let topWindow = application.windows.last {
            presentingWindow?.windowLevel = topWindow.windowLevel + 1
        }
        
        presentingWindow?.makeKeyAndVisible()
        
        if let vc = presentingWindow?.rootViewController {
            self.showBulletin(above: vc, animated: animated, completion: completion)
        }
        
    }

    /**
     * Dismisses the bulletin and clears the current page. You will have to call `prepare` before
     * presenting the bulletin again.
     *
     * This method will call the `dismissalHandler` block of the current item if it was set.
     *
     * - parameter animated: Whether to animate dismissal. Defaults to `true`.
     */

    @objc(dismissBulletinAnimated:)
    public func dismissBulletin(animated: Bool = true) {

        assertIsPrepared()
        assertIsMainThread()

        currentItem.tearDown()
        currentItem.manager = nil

        bulletinController.dismiss(animated: animated) {
            self.completeDismissal()
        }

        isPrepared = false

    }

    /**
     * Tears down the view controller and item stack after dismissal is finished.
     */

    @nonobjc func completeDismissal() {

        currentItem.onDismiss()

        for arrangedSubview in bulletinController.contentStackView.arrangedSubviews {
            bulletinController.contentStackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        
        presentingWindow?.isHidden = true
        presentingWindow = nil

        bulletinController.backgroundView = nil
        bulletinController.manager = nil
        bulletinController.transitioningDelegate = nil

        bulletinController = nil

        currentItem = self.rootItem
        itemsStack.removeAll()

    }

}

// MARK: - Transitions

extension BLTNItemManager {

    var needsCloseButton: Bool {
        return currentItem.isDismissable && currentItem.requiresCloseButton
    }

    /// Refreshes the interface for the current item.
    fileprivate func refreshCurrentItemInterface(elementsChanged: Bool = true) {

        bulletinController.isDismissable = false
        bulletinController.swipeInteractionController?.cancelIfNeeded()
        bulletinController.refreshSwipeInteractionController()

        let showActivityIndicator = self.shouldDisplayActivityIndicator
        let contentAlpha: CGFloat =  showActivityIndicator ? 0 : 1

        // Tear down old item

        let oldArrangedSubviews = bulletinController.contentStackView.arrangedSubviews
        let oldHideableArrangedSubviews = recursiveArrangedSubviews(in: oldArrangedSubviews)

        if elementsChanged {
            previousItem?.tearDown()
            previousItem?.manager = nil
            previousItem = nil
        }

        // Create new views

        let newArrangedSubviews = currentItem.makeArrangedSubviews()
        let newHideableArrangedSubviews = recursiveArrangedSubviews(in: newArrangedSubviews)

        if elementsChanged {

            currentItem.setUp()
            currentItem.manager = self

            for arrangedSubview in newHideableArrangedSubviews {
                arrangedSubview.isHidden = isPreparing ? false : true
            }

            for arrangedSubview in newArrangedSubviews {
                bulletinController.contentStackView.addArrangedSubview(arrangedSubview)
            }

        }

        // Animate transition

        let animationDuration = isPreparing ? 0 : 0.75
        let transitionAnimationChain = AnimationChain(duration: animationDuration)

        let hideSubviewsAnimationPhase = AnimationPhase(relativeDuration: 1/3, curve: .linear)

        hideSubviewsAnimationPhase.block = {

            if !showActivityIndicator {
                self.bulletinController.hideActivityIndicator()
            }

            for arrangedSubview in oldArrangedSubviews {
                arrangedSubview.alpha = 0
            }

            for arrangedSubview in newArrangedSubviews {
                arrangedSubview.alpha = 0
            }

        }

        let displayNewItemsAnimationPhase = AnimationPhase(relativeDuration: 1/3, curve: .linear)

        displayNewItemsAnimationPhase.block = {

            for arrangedSubview in oldHideableArrangedSubviews {
                arrangedSubview.isHidden = true
            }

            for arrangedSubview in newHideableArrangedSubviews {
                arrangedSubview.isHidden = false
            }

        }
        
        displayNewItemsAnimationPhase.completionHandler = {
            self.currentItem.willDisplay()
        }

        let finalAnimationPhase = AnimationPhase(relativeDuration: 1/3, curve: .linear)

        finalAnimationPhase.block = {

            let currentElements = elementsChanged ? newArrangedSubviews : oldArrangedSubviews
            self.bulletinController.contentStackView.alpha = contentAlpha
            self.bulletinController.updateCloseButton(isRequired: self.needsCloseButton && !showActivityIndicator)

            for arrangedSubview in currentElements {
                arrangedSubview.alpha = contentAlpha
            }

        }

        finalAnimationPhase.completionHandler = {

            self.bulletinController.isDismissable = self.currentItem.isDismissable && (showActivityIndicator == false)

            if elementsChanged {

                self.currentItem.onDisplay()

                for arrangedSubview in oldArrangedSubviews {
                    self.bulletinController.contentStackView.removeArrangedSubview(arrangedSubview)
                    arrangedSubview.removeFromSuperview()
                }

            }

            UIAccessibility.post(notification: .screenChanged, argument: newArrangedSubviews.first)

        }

        // Perform animation

        if elementsChanged {
            transitionAnimationChain.add(hideSubviewsAnimationPhase)
            transitionAnimationChain.add(displayNewItemsAnimationPhase)
        } else {
            bulletinController.hideActivityIndicator()
        }

        transitionAnimationChain.add(finalAnimationPhase)
        transitionAnimationChain.start()

    }

    /// Tears down every item on the stack starting from the specified item.
    fileprivate func tearDownItemsChain(startingAt item: BLTNItem) {

        item.tearDown()
        item.manager = nil

        if let next = item.next {
            tearDownItemsChain(startingAt: next)
            item.next = nil
        }

    }

    /// Returns all the arranged subviews.
    private func recursiveArrangedSubviews(in views: [UIView]) -> [UIView] {

        var arrangedSubviews: [UIView] = []

        for view in views {

            if let stack = view as? UIStackView {
                arrangedSubviews.append(stack)
                let recursiveViews = self.recursiveArrangedSubviews(in: stack.arrangedSubviews)
                arrangedSubviews.append(contentsOf: recursiveViews)
            } else {
                arrangedSubviews.append(view)
            }

        }

        return arrangedSubviews

    }

}

// MARK: - Utilities

extension BLTNItemManager {

    fileprivate func assertIsMainThread() {
        precondition(Thread.isMainThread, "BLTNItemManager must only be used from the main thread.")
    }

    fileprivate func assertIsPrepared() {
        precondition(isPrepared, "You must call the `prepare` function before interacting with the bulletin.")
    }

}
