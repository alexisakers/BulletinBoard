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


    // MARK: - Private Interface Elements

    fileprivate let activityIndicator = ActivityIndicator()
    fileprivate let bottomSafeAreaCoverView = UIVisualEffectView()
    fileprivate var swipeInteractionController: BulletinSwipeInteractionController!

    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var centerXConstraint: NSLayoutConstraint!
    private var minWidthConstraint: NSLayoutConstraint!

    private var stackLeadingConstraint: NSLayoutConstraint!
    private var stackTrailingConstraint: NSLayoutConstraint!
    private var stackBottomConstraint: NSLayoutConstraint!
    private var contentTopConstraint: NSLayoutConstraint!

    private var contentBottomConstraint: NSLayoutConstraint!


    // MARK: - Lifecycle

    weak var manager: BulletinManager?

    override func loadView() {

        super.loadView()
        view.backgroundColor = .clear

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
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

        minWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: 444)
        minWidthConstraint.priority = UILayoutPriorityDefaultHigh

        let maxWidthConstraint = contentView.widthAnchor.constraint(lessThanOrEqualTo: view.safeWidthAnchor, constant: -24)
        maxWidthConstraint.priority = UILayoutPriorityRequired
        maxWidthConstraint.isActive = true

        // Content Stack View

        contentView.addSubview(contentStackView)

        stackLeadingConstraint = contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36)
        stackLeadingConstraint.isActive = true

        stackTrailingConstraint = contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36)
        stackTrailingConstraint.isActive = true

        let minYConstraint = contentView.topAnchor.constraint(greaterThanOrEqualTo: view.safeTopAnchor)
        minYConstraint.isActive = true
        minYConstraint.priority = UILayoutPriorityRequired

        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill

        // Activity Indicator

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(activityIndicator)
        activityIndicator.leftAnchor.constraint(equalTo: contentStackView.leftAnchor).isActive = true
        activityIndicator.rightAnchor.constraint(equalTo: contentStackView.rightAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: contentStackView.topAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor).isActive = true

        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .black
        activityIndicator.isUserInteractionEnabled = true

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

        contentView.backgroundColor = #colorLiteral(red: 0.9921568627, green: 1, blue: 1, alpha: 1)
        setUpLayout(with: traitCollection)

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
            centerXConstraint.isActive = true
            minWidthConstraint.isActive = true

        case .compact:
            leadingConstraint.isActive = true
            trailingConstraint.isActive = true
            centerXConstraint.isActive = false
            minWidthConstraint.isActive = false

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

        if let isDark = manager?.backgroundViewStyle.isDark {
            return isDark ? .lightContent : .default
        }

        return .default
        
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

        guard let isDark = manager?.backgroundViewStyle.isDark else {
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
    func displayActivityIndicator() {

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
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0
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

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController.isInteractionInProgress ? swipeInteractionController : nil
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

// MARK: - Swift Compatibility

#if swift(>=4.0)
private let UILayoutPriorityRequired = UILayoutPriority.required
private let UILayoutPriorityDefaultHigh = UILayoutPriority.defaultHigh
private let UILayoutPriorityDefaultLow = UILayoutPriority.defaultLow
#endif
