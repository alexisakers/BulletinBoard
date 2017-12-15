/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A view controller that displays a card at the bottom of the screen.
 */

final class BulletinViewController: UIViewController, UIGestureRecognizerDelegate {

    /// The subview that contains the contents of the card.
    let contentView = UIView()

    /// The view covering the content. Generated in `loadBackgroundView`.
    var backgroundView: BulletinBackgroundView!

    /// The snapshot view of the content used during dismissal.
    var activeSnapshotView: UIView?

    /// Indicates whether the bulletin can be dismissed by a tap outside the card.
    var isDismissable: Bool = false

    /**
     * The stack view displaying the content of the card.
     *
     * - warning: You should not customize the distribution, axis and alignment of the stack, as this
     * may break the layout of the card.
     */

    let contentStackView = UIStackView()
    
    let activityIndicator = ActivityIndicator()


    // MARK: - Private Interface Elements

    fileprivate let bottomSafeAreaCoverView = UIVisualEffectView()
    fileprivate var swipeInteractionController: BulletinSwipeInteractionController!

    // Compact constraints
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var centerXConstraint: NSLayoutConstraint!

    // Regular constraints
    private var widthConstraint: NSLayoutConstraint!
    fileprivate var centerYConstraint: NSLayoutConstraint!

    // Stack view constraints
    private var stackLeadingConstraint: NSLayoutConstraint!
    private var stackTrailingConstraint: NSLayoutConstraint!
    private var stackBottomConstraint: NSLayoutConstraint!

    // Position constraints
    fileprivate var minYConstraint: NSLayoutConstraint!
    private var contentTopConstraint: NSLayoutConstraint!
    fileprivate var contentBottomConstraint: NSLayoutConstraint!


    // MARK: - Lifecycle

    weak var manager: BulletinManager?

    override func loadView() {

        super.loadView()
        view.backgroundColor = .clear

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        recognizer.delegate = self
        recognizer.cancelsTouchesInView = false
        recognizer.delaysTouchesEnded = false

        view.addGestureRecognizer(recognizer)

        contentView.accessibilityViewIsModal = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentView)

        // Content View

        contentView.layer.cornerRadius = 12

        leadingConstraint = contentView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 12)
        trailingConstraint = contentView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -12)
        centerXConstraint = contentView.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor)

        centerYConstraint = contentView.centerYAnchor.constraint(equalTo: view.safeCenterYAnchor)
        centerYConstraint.constant = 2500

        widthConstraint = contentView.widthAnchor.constraint(equalToConstant: 444)
        widthConstraint.priority = UILayoutPriorityRequired

        let maxWidthConstraint = contentView.widthAnchor.constraint(lessThanOrEqualTo: view.safeWidthAnchor, constant: -24)
        maxWidthConstraint.priority = UILayoutPriorityRequired
        maxWidthConstraint.isActive = true

        // Content Stack View

        contentView.addSubview(contentStackView)

        stackLeadingConstraint = contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36)
        stackLeadingConstraint.isActive = true

        stackTrailingConstraint = contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36)
        stackTrailingConstraint.isActive = true

        minYConstraint = contentView.topAnchor.constraint(greaterThanOrEqualTo: view.safeTopAnchor)
        minYConstraint.isActive = true
        minYConstraint.priority = UILayoutPriorityRequired

        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill

        // Activity Indicator

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(activityIndicator)
        activityIndicator.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        activityIndicator.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .black
        activityIndicator.isUserInteractionEnabled = false

        activityIndicator.alpha = 0

        // Safe Area Cover View

        bottomSafeAreaCoverView.effect = nil
        bottomSafeAreaCoverView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSafeAreaCoverView)

        bottomSafeAreaCoverView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        bottomSafeAreaCoverView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        bottomSafeAreaCoverView.topAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        bottomSafeAreaCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // Vertical Position

        stackBottomConstraint = contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        contentTopConstraint = contentView.topAnchor.constraint(equalTo: contentStackView.topAnchor)

        stackBottomConstraint.isActive = true
        contentTopConstraint.isActive = true

        contentBottomConstraint = contentView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor)
        contentBottomConstraint.constant = 1000
        contentBottomConstraint.isActive = true

        // Configuration

        contentView.backgroundColor = manager?.backgroundColor ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpKeyboardLogic()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpLayout(with: traitCollection)
    }

    deinit {
        cleanUpKeyboardLogic()
    }
    
    // MARK: - Gesture Recognizer
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: contentView) == true {
            return false
        }
        
        return true
    }

    // MARK: - Layout

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {

        coordinator.animate(alongsideTransition: { _ in
            self.setUpLayout(with: newCollection)
        })

    }

    private func setUpLayout(with traitCollection: UITraitCollection) {

        switch traitCollection.horizontalSizeClass {
        case .regular:
            leadingConstraint.isActive = false
            trailingConstraint.isActive = false
            contentBottomConstraint.isActive = false
            centerXConstraint.isActive = true
            centerYConstraint.isActive = true
            widthConstraint.isActive = true

        case .compact:
            leadingConstraint.isActive = true
            trailingConstraint.isActive = true
            contentBottomConstraint.isActive = true
            centerXConstraint.isActive = false
            centerYConstraint.isActive = false
            widthConstraint.isActive = false

        default:
            break
        }

        switch (traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass) {
        case (.regular, .regular):
            stackLeadingConstraint.constant = 32
            stackTrailingConstraint.constant = -32
            stackBottomConstraint.constant = -32
            contentTopConstraint.constant = -32
            contentStackView.spacing = 32

        default:
            stackLeadingConstraint.constant = 24
            stackTrailingConstraint.constant = -24
            stackBottomConstraint.constant = -24
            contentTopConstraint.constant = -24
            contentStackView.spacing = 24

        }

    }

    // MARK: - Transition Adaptivity

    /// Moves the content view to its final location on the screen. Use during presentation.
    func moveIntoPlace() {

        contentBottomConstraint.constant = -12
        centerYConstraint.constant = 0

        view.layoutIfNeeded()
        contentView.layoutIfNeeded()
        backgroundView.layoutIfNeeded()

    }

    // MARK: - Presentation/Dismissal

    /// Dismisses the presnted BulletinViewController if `isDissmisable` is set to `true`.
    @discardableResult
    func dismissIfPossible() -> Bool {
    
        guard isDismissable else {
            return false
        }
    
        manager?.dismissBulletin(animated: true)
        return true

    }

    // MARK: - Touch Events

    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        dismissIfPossible()
    }
    
    // MARK: - Accessibility
    
    override func accessibilityPerformEscape() -> Bool {
        return dismissIfPossible()
    }

    // MARK: - Background Accomodations

    override var preferredStatusBarStyle: UIStatusBarStyle {

        switch manager?.statusBarAppearance {
        case .lightContent?:
            return .lightContent

        case .automatic?:

            if let isDark = manager?.backgroundViewStyle.rawValue.isDark {
                return isDark ? .lightContent : .default
            } else {
                fallthrough
            }

        default:
            return .default
        }
        
    }

    override var prefersStatusBarHidden: Bool {
        return manager?.statusBarAppearance == .hidden
    }

}

// MARK: - Background

extension BulletinViewController {

    /// Creates a new background view for the bulletin.
    func loadBackgroundView() {
        backgroundView = BulletinBackgroundView(style: manager?.backgroundViewStyle ?? .dimmed)
    }

    /// Displays the cover view at the bottom of the safe area. Animatable.
    func showBottomSafeAreaCover() {

        guard let isDark = manager?.backgroundViewStyle.rawValue.isDark else {
            return
        }

        let blurStyle: UIBlurEffectStyle = isDark ? .dark : .extraLight
        bottomSafeAreaCoverView.effect = UIBlurEffect(style: blurStyle)

    }

    /// Hides the cover view at the bottom of the safe area. Animatable.
    func hideBottomSafeAreaCover() {
        bottomSafeAreaCoverView.effect = nil
    }

}

// MARK: - Activity Indicator

extension BulletinViewController {

    /// Displays the activity indicator.
    func displayActivityIndicator(color: UIColor) {

        activityIndicator.color = color
        activityIndicator.startAnimating()

        let animations = {
            self.activityIndicator.alpha = 1
            self.contentStackView.alpha = 0
        }

        UIView.animate(withDuration: 0.25, animations: animations) { _ in
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.activityIndicator)
        }

    }

    /// Hides the activity indicator.
    func hideActivityIndicator(showContentStack: Bool) {

        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0

        let animations = {
            self.activityIndicator.alpha = 0

            if showContentStack {
                self.contentStackView.alpha = 1
            }
        }

        UIView.animate(withDuration: 0.25, animations: animations)

    }

}

// MARK: - Transitions

extension BulletinViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BulletinPresentationAnimationController(style: manager?.backgroundViewStyle ?? .dimmed)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BulletinDismissAnimationController()
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            let isEligible = swipeInteractionController.isInteractionInProgress
            return isEligible ? swipeInteractionController : nil
    }

    /// Creates a new view swipe interaction controller and wires it to the content view.
    func refreshSwipeInteractionController() {
        swipeInteractionController = BulletinSwipeInteractionController()
        swipeInteractionController.wire(to: self)
    }

    /// Prepares the view controller for dismissal.
    func prepareForDismissal(displaying snapshot: UIView) {
        view.bringSubview(toFront: bottomSafeAreaCoverView)
        activeSnapshotView = snapshot
    }

}

// MARK: - Keyboard

extension BulletinViewController {
    func setUpKeyboardLogic() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide), name: .UIKeyboardWillHide, object: nil)
    }

    func cleanUpKeyboardLogic() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    @objc func onKeyboardShow(_ notification: Notification) {

        guard manager?.currentItem.shouldRespondToKeyboardChanges == true else {
            return
        }

        guard let userInfo = notification.userInfo,
            let keyboardFrameFinal = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curveInt = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int
        else {
            return
        }

        let animationCurve = UIViewAnimationCurve(rawValue: curveInt) ?? .linear
        let animationOptions = UIViewAnimationOptions(curve: animationCurve)

        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            var bottomSpacing = -(keyboardFrameFinal.size.height + 12)
            if #available(iOS 11, *) {
                bottomSpacing += self.view.safeAreaInsets.bottom
            }
            self.minYConstraint.isActive = false
            self.contentBottomConstraint.constant = bottomSpacing
            self.centerYConstraint.constant = -(keyboardFrameFinal.size.height + 12) / 2
            self.contentView.superview?.layoutIfNeeded()
        }, completion: nil)

    }

    @objc func onKeyboardHide(_ notification: Notification) {

        guard manager?.currentItem.shouldRespondToKeyboardChanges == true else {
            return
        }

        guard let userInfo = notification.userInfo,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curveInt = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int
        else {
            return
        }

        let animationCurve = UIViewAnimationCurve(rawValue: curveInt) ?? .linear
        let animationOptions = UIViewAnimationOptions(curve: animationCurve)

        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            self.minYConstraint.isActive = true
            self.contentBottomConstraint.constant = -12 // same value as in moveIntoPlace()
            self.centerYConstraint.constant = 0
            self.contentView.superview?.layoutIfNeeded()
        }, completion: nil)
        
    }
}

extension UIViewAnimationOptions {
    init(curve: UIViewAnimationCurve) {
        self = UIViewAnimationOptions(rawValue: UInt(curve.rawValue << 16))
    }
}

// MARK: - Swift Compatibility

#if swift(>=4.0)
let UILayoutPriorityRequired = UILayoutPriority.required
let UILayoutPriorityDefaultHigh = UILayoutPriority.defaultHigh
let UILayoutPriorityDefaultLow = UILayoutPriority.defaultLow
#endif
