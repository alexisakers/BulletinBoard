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

@available(*, deprecated: 4.0, renamed: "BLTNViewController")
@objc public final class BLTNItemManager: NSObject {

    /// Bulletin view controller.
    fileprivate let bulletinController: BLTNViewController

    // MARK: - Background

    /**
     * The background color of the bulletin card. Defaults to white.
     * - warning: Using the manager is deprecated and will be removed in a future version of BTLNBoard.
     */

    @objc public var backgroundColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }()

    /**
     * The style of the view covering the content. Defaults to `.dimmed`.
     * - warning: Using the manager is deprecated and will be removed in a future version of BTLNBoard.
     */

    @objc public var backgroundViewStyle: BLTNBackgroundViewStyle = .dimmed

    // MARK: - Status Bar

    /**
     * The style of status bar to use with the bulltin. Defaults to `.automatic`.
     * - warning: Using the manager is deprecated and will be removed in a future version of BTLNBoard.
     */

    @objc public var statusBarAppearance: BLTNStatusBarAppearance = .automatic

    /**
     * The style of status bar animation. Defaults to `.fade`.
     * - warning: Using the manager is deprecated and will be removed in a future version of BTLNBoard.
     */

    @objc public var statusBarAnimation: UIStatusBarAnimation = .fade

    /**
     * The home indicator for iPhone X should be hidden or not. Defaults to false.
     * - warning: Using the manager is deprecated and will be removed in a future version of BTLNBoard.
     */

    @objc public var hidesHomeIndicator: Bool = false

    // MARK: - Card Presentation

    /**
     * The spacing between the edge of the screen and the edge of the card. Defaults to regular.
     * - warning: Using the manager is deprecated and will be removed in a future version of BTLNBoard.
     */

    @objc public var edgeSpacing: BLTNSpacing = .regular

    /**
     * The rounded corner radius of the bulletin card. Defaults to 12, and 36 on iPhone X.
     * - warning: Using the manager is deprecated and will be removed in a future version of BTLNBoard.
     */

    @objc public var cardCornerRadius: NSNumber?

    /**
     * Whether swipe to dismiss should be allowed. Defaults to true.
     * - warning: Using the manager is deprecated and will be removed in a future version of BTLNBoard.
     */

    @objc public var allowsSwipeInteraction: Bool = true
    
    /**
     * Tells us if a bulletin is currently being shown. Defaults to false
     * - warning: Using the manager is deprecated and will be removed in a future version of BTLNBoard.
     */

    @available(*, deprecated, message: "Using the manager is deprecated. Create a view controller directly.")
    @objc public var isShowingBulletin: Bool { 
        return bulletinController.presentingViewController != nil
    }

    // MARK: - Private Properties

    fileprivate var presentingWindow: UIWindow?
    fileprivate var isPrepared: Bool = false

    // MARK: - Initialization

    /**
     * Creates a bulletin manager and sets the first item to display.s
     * - parameter rootItem: The first item to display.
     */

    @objc public init(rootItem: BLTNItem) {
        self.bulletinController = BLTNViewController(rootItem: rootItem)
    }


    @available(*, unavailable, message: "Use init(rootItem:) instead.")
    override init() {
        fatalError("BLTNItemManager.init is unavailable. Use init(rootItem:) instead.")
    }

    // MARK: - Interacting with the Bulletin

    /**
     * Prepares the bulletin interface and displays the root item.
     *
     * This method must be called before any other interaction with the bulletin.
     */

    fileprivate func prepare() {
        assertIsMainThread()

        // deprecation transisiton: assign all properties here
        bulletinController.backgroundColor = backgroundColor
        bulletinController.backgroundViewStyle = backgroundViewStyle
        bulletinController.statusBarAppearance = statusBarAppearance
        bulletinController.hidesHomeIndicator = hidesHomeIndicator
        bulletinController.edgeSpacing = edgeSpacing
        bulletinController.cardCornerRadius = cardCornerRadius
        bulletinController.allowsSwipeInteraction = allowsSwipeInteraction

        // update the prepared sate
        isPrepared = true
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
     * - parameter color: The color of the activity indicator to display. Defaults to .label on iOS 13 and .black on older systems.
     *
     * Displaying the loading indicator does not change the height of the page or the current item.
     */

    @objc public func displayActivityIndicator(color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) {
        assertIsPrepared()
        assertIsMainThread()
        bulletinController.activityIndicatorColor = color
        bulletinController.displayActivityIndicator()
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
        bulletinController.hideActivityIndicator()
    }

    /**
     * Displays the next item, if the `next` property of the current item is set.
     *
     * - warning: If you call this method but `next` is `nil`, an exception will be raised.
     */

    @objc public func displayNextItem() {
        assertIsPrepared()
        assertIsMainThread()
        bulletinController.displayNextItem()
    }

    // MARK: - Presentation / Dismissal

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



        bulletinController.dismiss(animated: animated) {
            self.presentingWindow?.isHidden = true
            self.presentingWindow = nil
        }

        isPrepared = false
    }

    // MARK: - Utilities

    fileprivate func assertIsMainThread() {
        precondition(Thread.isMainThread, "BLTNItemManager must only be used from the main thread.")
    }

    fileprivate func assertIsPrepared() {
        precondition(isPrepared, "You must call the `prepare` function before interacting with the bulletin.")
    }

}
