/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A view controller that displays a BulletinBoard card on top of the current context.
 *
 * You create a bulletin view controller using the `init(rootItem:)` initializer, where `rootItem` is the
 * first bulletin item to display. An item represents the contents displayed on a single card. You present
 * the view controller like a normal view controller.
 *
 * To change the displayed card, you can push new items to the stack to display them, and pop existing
 * ones to go back. It also possible to display and hide an activity indicator while you are performing
 * long tasks and want to hide the content.
 *
 * You can configure the appearance and behavior of the `BLTNViewController` with properties such as
 * the background color, status bar appearance and swiping interactions. These properties also support
 * the `UIAppearance` proxy.
 */

@objc public final class BLTNViewController: UIViewController, UIGestureRecognizerDelegate {

    /**
     * Whether swipe-to-dismiss should be allowed. Defaults to `true`.
     *
     * If you set this value to true, the user will be able to drag the card, and swipe down to
     * dismiss it (if allowed by the current item).
     *
     * If you set this value to `false`, no pan gesture will be recognized, and swipe to dismiss
     * won't be available.
     */

    @objc public dynamic var allowsSwipeInteraction: Bool = true

    /// The view that displays the card.
    @objc public var card: UIView {
        return contentView
    }

    // MARK: - Customizing the Appearance

    /// The background color of the bulletin card. Defaults to white.
    @objc public dynamic var backgroundColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            updateBackgroundColor()
        }
    }

    /// The style of the view covering the content. Defaults to `.dimmed`.
    @objc public dynamic var backgroundViewStyle: BLTNBackgroundViewStyle = .dimmed {
        didSet {
            backgroundView.style = backgroundViewStyle
        }
    }

    // MARK: - Customizing the Status Bar

    /// The style of status bar to use with the bulltin. Defaults to `.automatic`.
    @objc public dynamic var statusBarAppearance: BLTNStatusBarAppearance = .automatic {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    /// The style of status bar animation. Defaults to `.fade`.
    @objc public dynamic var statusBarAnimation: UIStatusBarAnimation = .fade

    /// The home indicator for iPhone X should be hidden or not. Defaults to false.
    @objc public dynamic var hidesHomeIndicator: Bool = false {
        didSet {
            if #available(iOS 11, *) {
                setNeedsUpdateOfHomeIndicatorAutoHidden()
            }
        }
    }

    /// The tint color to use for the activity indicator.
    @objc public dynamic var activityIndicatorColor: UIColor = .black {
        didSet {
            activityIndicator.color = activityIndicatorColor
        }
    }

    // MARK: - Customizing the Card Presentation

    /// The spacing between the edge of the screen and the edge of the card. Defaults to regular.
    @objc public dynamic var edgeSpacing: BLTNSpacing = .regular {
        didSet {
            updateEdgeSpacing()
        }
    }

    /// The rounded corner radius of the bulletin card. Defaults to 12, and 36 on iPhone X.
    @objc public dynamic var cardCornerRadius: NSNumber? {
        didSet {
            updateCornerRadius()
        }
    }

    // MARK: - Internal Properties

    /// Controls the state of the items.
    let stateController: BLTNStateController

    // MARK: - UI Elements

    /// The subview that contains the contents of the card.
    let contentView = RoundedView()

    /// The button that allows the users to close the bulletin.
    let closeButton = BulletinCloseButton()

    /// The stack view displaying the content of the card.
    let contentStackView = UIStackView()

    /// The view covering the content.
    let backgroundView = BulletinBackgroundView()

    /// The activity indicator.
    let activityIndicator = ActivityIndicator()

    // MARK: - Dismissal Support Properties

    /// Indicates whether the bulletin can be dismissed by a tap outside the card.
    var isDismissable: Bool = false

    /// The snapshot view of the content used during dismissal.
    var activeSnapshotView: UIView?

    /// The active swipe interaction controller.
    var swipeInteractionController: BulletinSwipeInteractionController!

    // MARK: - Private Interface Elements

    // Compact constraints
    fileprivate var leadingConstraint: NSLayoutConstraint!
    fileprivate var trailingConstraint: NSLayoutConstraint!
    fileprivate var centerXConstraint: NSLayoutConstraint!

    // Regular constraints
    fileprivate var widthConstraint: NSLayoutConstraint!
    fileprivate var centerYConstraint: NSLayoutConstraint!

    // Stack view constraints
    fileprivate var stackLeadingConstraint: NSLayoutConstraint!
    fileprivate var stackTrailingConstraint: NSLayoutConstraint!
    fileprivate var stackBottomConstraint: NSLayoutConstraint!

    // Position constraints
    fileprivate var contentTopConstraint: NSLayoutConstraint!
    fileprivate var contentBottomConstraint: NSLayoutConstraint!

    // MARK: - Initialization

    deinit {
        cleanUpKeyboardLogic()
    }

    /**
     * Creates a view controller to display the bulletin.
     * - parameter rootItem: The item to show first.
     */

    @objc public init(rootItem: BLTNItem) {
        self.stateController = BLTNStateController(rootItem: rootItem)
        super.init(nibName: nil, bundle: nil)

        stateController.delegate = self
        modalPresentationCapturesStatusBarAppearance = true
        modalPresentationStyle = .overFullScreen
        transitioningDelegate = self
    }

    @available(*, unavailable, message: "Use init(rootItem:) instead.")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) is unavailable. Use init(rootItem:) instead.")
    }

    @available(*, unavailable, message: "Use init(rootItem:) instead.")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is unavailable. Use init(rootItem:) instead.")
    }

    // MARK: - Lifecycle

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentBottomConstraint.constant = -bottomMargin
        setUpLayout(with: traitCollection)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /// Animate status bar appearance when hiding
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayout(with: traitCollection)
    }

    @available(iOS 11.0, *)
    override public func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        updateCornerRadius()
        setUpLayout(with: traitCollection)
    }

    override public func loadView() {
        super.loadView()
        view.backgroundColor = .clear

        // Tap to dismiss
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        recognizer.delegate = self
        recognizer.cancelsTouchesInView = false
        recognizer.delaysTouchesEnded = false
        view.addGestureRecognizer(recognizer)

        // Background View
        backgroundView.style = backgroundViewStyle

        // Content View
        contentView.accessibilityViewIsModal = true
        view.addSubview(contentView)

        // Close button
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        contentView.addSubview(closeButton)

        // Content Stack View
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentView.addSubview(contentStackView)

        // Activity Indicator
        activityIndicator.alpha = 0
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .black
        activityIndicator.isUserInteractionEnabled = false
        contentView.addSubview(activityIndicator)

        configureConstraints()

        // Configuration
        updateBackgroundColor()
        updateEdgeSpacing()
        setUpKeyboardLogic()

        refreshInterface(currentItem: stateController.rootItem, previousItem: nil)
        contentView.bringSubviewToFront(closeButton)
    }

    /// Configure the constraints of the view.
    private func configureConstraints() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        // Card: Horizontal
        leadingConstraint = contentView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor)
        trailingConstraint = contentView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor)
        centerXConstraint = contentView.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor)
        widthConstraint = contentView.widthAnchor.constraint(equalToConstant: 444)

        stackLeadingConstraint = contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        stackTrailingConstraint = contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

        // Card: Vertical
        contentTopConstraint = contentView.topAnchor.constraint(equalTo: contentStackView.topAnchor)
        stackBottomConstraint = contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        contentBottomConstraint = contentView.bottomAnchor.constraint(equalTo: safeBottomAnchor)

        // Card: Vertical (Regular)
        centerYConstraint = contentView.centerYAnchor.constraint(equalTo: view.safeCenterYAnchor)

        NSLayoutConstraint.activate([
            // activityIndicator
            activityIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // closeButton
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44),

            // contentStackView
            stackLeadingConstraint,
            stackTrailingConstraint,
            contentTopConstraint,
            stackBottomConstraint,
        ])
    }

    // MARK: - Gesture Recognizer`

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: contentView) == true {
            return false
        }

        return true
    }

}

// MARK: - State

extension BLTNViewController: BLTNStateControllerDelegate {

    /**
     * Displays a new item after the current one.
     * - parameter item: The item to display.
     */

    @objc public func push(item: BLTNItem) {
        stateController.push(item: item)
    }

    /**
     * Removes the current item from the stack and displays the previous item.
     */

    @objc public func popItem() {
        stateController.popItem()
    }

    /**
     * Removes all the items from the stack and displays the root item.
     */

    @objc public func popToRootItem() {
        stateController.popToRootItem()
    }

    /**
     * Displays the next item, if the `next` property of the current item is set.
     * - warning: If you call this method but `next` is `nil`, it will cause a crash.
     */

    @objc public func displayNextItem() {
        stateController.displayNextItem()
    }

}

// MARK: - State Updating

extension BLTNViewController {

    func stateController(_ controller: BLTNStateController, didUpdateCurrentItem currentItem: BLTNItem, previousItem: BLTNItem?) {
        refreshInterface(currentItem: currentItem, previousItem: previousItem)
    }

    /// Refreshes the interface for the current item.
    fileprivate func refreshInterface(currentItem: BLTNItem, previousItem: BLTNItem?) {
        isDismissable = false
        updateCloseButton(isRequired: false)
        swipeInteractionController?.cancelIfNeeded()
        refreshSwipeInteractionController()

        let isInitialLayout = contentStackView.arrangedSubviews.isEmpty

        // Prepare the loading indicator animation
        let showActivityIndicator = currentItem.shouldStartWithActivityIndicator

        // Tear down old item
        let oldArrangedSubviews = contentStackView.arrangedSubviews
        let oldHideableArrangedSubviews = recursiveArrangedSubviews(in: oldArrangedSubviews)

        // Create new views
        let newArrangedSubviews = currentItem.makeArrangedSubviews()
        let newHideableArrangedSubviews = recursiveArrangedSubviews(in: newArrangedSubviews)

        currentItem.setUp()
        currentItem.parent = self

        // Hide the new views if needed before we transition
        for arrangedSubview in newHideableArrangedSubviews {
            arrangedSubview.isHidden = !isInitialLayout
        }

        for arrangedSubview in newArrangedSubviews {
            contentStackView.addArrangedSubview(arrangedSubview)
        }

        // Animate transition
        let animationDuration = isInitialLayout ? 0 : 0.75
        let transitionAnimationChain = AnimationChain(duration: animationDuration)

        // 1) Hide the previous subviews
        let hideSubviewsAnimationPhase = AnimationPhase(relativeDuration: 1/3, curve: .linear)

        hideSubviewsAnimationPhase.block = {
            for arrangedSubview in oldArrangedSubviews {
                arrangedSubview.alpha = 0
            }

            for arrangedSubview in newArrangedSubviews {
                arrangedSubview.alpha = 0
            }
        }

        hideSubviewsAnimationPhase.completionHandler = {
            if !showActivityIndicator {
                self.hideActivityIndicator()
            }
        }

        // 2) Relayout the stack with the new views
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
            currentItem.willPresent()
            previousItem?.willDismiss()
        }

        // 3) Uncover the new views
        let finalAnimationPhase = AnimationPhase(relativeDuration: 1/3, curve: .linear)

        finalAnimationPhase.block = {
            self.contentStackView.alpha = showActivityIndicator ? 0 : 1
            self.updateCloseButton(isRequired: self.stateController.needsCloseButton)

            if showActivityIndicator {
                self.displayActivityIndicator()
            }

            for arrangedSubview in newArrangedSubviews {
                arrangedSubview.alpha = 1
            }
        }

        // 4) Remove the old subviews
        finalAnimationPhase.completionHandler = {
            self.isDismissable = currentItem.isDismissable

            currentItem.didPresent()
            previousItem?.didDismiss()

            for arrangedSubview in oldArrangedSubviews {
                self.contentStackView.removeArrangedSubview(arrangedSubview)
                arrangedSubview.removeFromSuperview()
            }

            if !showActivityIndicator {
                UIAccessibility.post(notification: .screenChanged, argument: newArrangedSubviews.first)
            }
        }

        // Perform animation
        transitionAnimationChain.add(hideSubviewsAnimationPhase)
        transitionAnimationChain.add(displayNewItemsAnimationPhase)
        transitionAnimationChain.add(finalAnimationPhase)
        transitionAnimationChain.start()
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

// MARK: - Layout

extension BLTNViewController {

    override public func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.setUpLayout(with: newCollection)
        })
    }

    fileprivate func setUpLayout(with traitCollection: UITraitCollection) {
        switch traitCollection.horizontalSizeClass {
        case .regular:
            NSLayoutConstraint.deactivate([leadingConstraint, trailingConstraint, contentBottomConstraint])
            NSLayoutConstraint.activate([centerXConstraint, centerYConstraint, widthConstraint])

            stackLeadingConstraint.constant = 32
            stackTrailingConstraint.constant = -32
            stackBottomConstraint.constant = -32
            contentTopConstraint.constant = -32
            contentStackView.spacing = 32

        default:
            NSLayoutConstraint.deactivate([centerXConstraint, centerYConstraint, widthConstraint])
            NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, contentBottomConstraint])

            stackLeadingConstraint.constant = 24
            stackTrailingConstraint.constant = -24
            stackBottomConstraint.constant = -24
            contentTopConstraint.constant = -24
            contentStackView.spacing = 24
        }
    }

    // MARK: - Transition Adaptivity

    /// Returns the current bottom margin.
    var bottomMargin: CGFloat {
        return edgeSpacing.rawValue
    }

    // MARK: - Presentation/Dismissal

    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.stateController.currentItem.willDismiss()
        super.dismiss(animated: flag) {
            self.stateController.currentItem.didDismiss()
            completion?()
        }
    }

    /// Dismisses the presnted BulletinViewController if `isDissmisable` is set to `true`.
    @discardableResult func dismissIfPossible() -> Bool {
        guard isDismissable else {
            return false
        }

        dismiss(animated: true)
        return true
    }

    @objc fileprivate func handleTap(recognizer: UITapGestureRecognizer) {
        dismissIfPossible()
    }

    public override func accessibilityPerformEscape() -> Bool {
        return dismissIfPossible()
    }

}

// MARK: - System Elements

extension BLTNViewController {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        switch statusBarAppearance {
        case .lightContent:
            return .lightContent
        case .automatic:
            return backgroundViewStyle.rawValue.isDark ? .lightContent : .default
        default:
            return .default
        }
    }

    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return statusBarAnimation
    }

    public override var prefersStatusBarHidden: Bool {
        return statusBarAppearance == .hidden
    }

    @available(iOS 11.0, *)
    public override var prefersHomeIndicatorAutoHidden: Bool {
        return hidesHomeIndicator
    }

}

// MARK: - User Defined Appearance

extension BLTNViewController {

    /// The default radius to use on this device, if no override value was provided by the user.
    var defaultRadius: NSNumber {
        var defaultRadius: NSNumber = 12

        if #available(iOS 11.0, *) {
            defaultRadius = screenHasRoundedCorners ? 36 : 12
        }

        return defaultRadius
    }

    @available(iOS 11.0, *)
    private var screenHasRoundedCorners: Bool {
        return view.safeAreaInsets.bottom > 0
    }

    private func updateCornerRadius() {
        if edgeSpacing.rawValue == 0 {
            return contentView.cornerRadius = 0
        }

        contentView.cornerRadius = CGFloat((cardCornerRadius ?? defaultRadius).doubleValue)
    }

    private func updateEdgeSpacing() {
        updateCornerRadius()

        let padding = edgeSpacing.rawValue
        leadingConstraint.constant = padding
        trailingConstraint.constant = -padding
    }

    private func updateBackgroundColor() {
        contentView.backgroundColor = backgroundColor
        closeButton.updateColors(isDarkBackground: backgroundColor.needsDarkText)
    }

}

// MARK: - Activity Indicator

extension BLTNViewController {

    /**
     * Hides the contents of the stack and displays an activity indicator view.
     *
     * Use this method if you need to perform a long task or fetch some data before changing the item.
     *
     * Displaying the loading indicator does not change the height of the page or the current item. It will disable
     * dismissal by tapping and swiping to allow the task to complete and avoid resource deallocation.
     */

    @objc public func displayActivityIndicator() {
        activityIndicator.color = activityIndicatorColor
        activityIndicator.startAnimating()

        let animations = {
            self.contentStackView.alpha = 0
            self.activityIndicator.alpha = 1
        }

        UIView.animate(withDuration: 0.25, animations: animations) { _ in
            UIAccessibility.post(notification: .screenChanged, argument: self.activityIndicator)
        }
    }

    /**
     * Hides the activity indicator and displays the current item.
     *
     * You can also call one of `popItem`, `popToRootItem` and `pushItem` if you need to hide the activity
     * indicator and change the current item.
     */

    @objc public func hideActivityIndicator() {
        activityIndicator.stopAnimating()

        let animations = {
            self.activityIndicator.alpha = 0
            self.contentStackView.alpha = 1
        }

        UIView.animate(withDuration: 0.25, animations: animations)
    }

}

// MARK: - Close Button

extension BLTNViewController {

    /// Updates the visibility of the close button.
    func updateCloseButton(isRequired: Bool) {
        closeButton.alpha = isRequired ? 1 : 0
    }

    /// Handles a tap on the close button.
    @objc private func closeButtonTapped() {
        dismissIfPossible()
    }

}

// MARK: - Transitions

extension BLTNViewController: UIViewControllerTransitioningDelegate {

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BulletinPresentationAnimationController(style: backgroundViewStyle)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BulletinDismissAnimationController()
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            guard self.allowsSwipeInteraction == true else {
                return nil
            }

            let isEligible = swipeInteractionController.isInteractionInProgress
            return isEligible ? swipeInteractionController : nil
    }

    /// Creates a new view swipe interaction controller and wires it to the content view.
    func refreshSwipeInteractionController() {
        guard self.allowsSwipeInteraction == true else {
            return
        }

        swipeInteractionController = BulletinSwipeInteractionController()
        swipeInteractionController.wire(to: self)
    }

    /// Prepares the view controller for dismissal.
    func prepareForDismissal(displaying snapshot: UIView) {
        activeSnapshotView = snapshot
    }

}

// MARK: - Keyboard

extension BLTNViewController {

    /// Adds observers for the keyboard frame changes.
    func setUpKeyboardLogic() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /// Removes observers for the keyboard frame changes.
    func cleanUpKeyboardLogic() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /// Handles keyboard presentation.
    @objc func onKeyboardShow(_ notification: Notification) {
        guard stateController.currentItem.shouldRespondToKeyboardChanges == true else {
            return
        }

        guard let userInfo = notification.userInfo,
            let keyboardFrameFinal = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveInt = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
        else {
            return
        }

        let animationCurve = UIView.AnimationCurve(rawValue: curveInt) ?? .linear
        let animationOptions = UIView.AnimationOptions(curve: animationCurve)

        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            let bottomSpacing = -(keyboardFrameFinal.size.height + self.bottomMargin)

            self.contentBottomConstraint.constant = bottomSpacing
            self.centerYConstraint.constant = -(keyboardFrameFinal.size.height + 12) / 2
            self.contentView.superview?.layoutIfNeeded()
        
        }, completion: nil)

    }

    /// Handles keyboard dismissal.
    @objc func onKeyboardHide(_ notification: Notification) {
        guard stateController.currentItem.shouldRespondToKeyboardChanges == true else {
            return
        }

        guard let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveInt = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
        else {
            return
        }

        let animationCurve = UIView.AnimationCurve(rawValue: curveInt) ?? .linear
        let animationOptions = UIView.AnimationOptions(curve: animationCurve)

        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            self.contentBottomConstraint.constant = -self.bottomMargin
            self.centerYConstraint.constant = 0
            self.contentView.superview?.layoutIfNeeded()
        }, completion: nil)

    }
}

// MARK: - Helpers

extension UIView.AnimationOptions {

    /// Creates an animation option with the appropriate curve.
    @nonobjc init(curve: UIView.AnimationCurve) {
        self = UIView.AnimationOptions(rawValue: UInt(curve.rawValue << 16))
    }
}
