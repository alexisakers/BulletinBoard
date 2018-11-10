/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * An interaction controller that handles swipe-to-dismiss for bulletins.
 */

class BulletinSwipeInteractionController: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {

    /// Whether a panning interaction is in progress.
    var isInteractionInProgress = false

    var panGestureRecognizer: UIPanGestureRecognizer?

    // MARK: - State

    private var isFinished = false
    private var currentPercentage: CGFloat = -1
    private weak var viewController: BulletinViewController!

    private var snapshotView: UIView? {
        return viewController.activeSnapshotView
    }

    private var contentView: UIView {
        return viewController.contentView
    }

    private var activityIndicatorView: UIView {
        return viewController.activityIndicator
    }

    // MARK: - Preparation

    /**
     * Sets up the interaction recognizer for the given view controller and content view.
     */

    func wire(to viewController: BulletinViewController) {
        self.viewController = viewController
        prepareGestureRecognizer()
    }

    private func prepareGestureRecognizer() {

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.maximumNumberOfTouches = 1
        panGesture.cancelsTouchesInView = false
        panGesture.delegate = self

        self.panGestureRecognizer = panGesture
        contentView.addGestureRecognizer(panGesture)

    }


    // MARK: - Gesture Recognizer

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIControl)
    }

    @objc func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {

        /// Constants

        let screenHeight = viewController.view.bounds.height
        let distanceFactor: CGFloat = screenHeight >= 500 ? 3/4 : 2/3

        let dismissThreshold: CGFloat = 256 * distanceFactor
        let elasticThreshold: CGFloat = 128 * distanceFactor
        let trackScreenPercentage = dismissThreshold / contentView.bounds.height

        switch gestureRecognizer.state {
        case .began:

            isFinished = false

            gestureRecognizer.setTranslation(.zero, in: contentView)

            let isCompactWidth = viewController.traitCollection.horizontalSizeClass == .compact

            guard viewController.isDismissable && isCompactWidth else {
                isInteractionInProgress = false
                return
            }

            isInteractionInProgress = true

            viewController.dismiss(animated: true) {

                guard self.isFinished else {
                    return
                }

                self.viewController.manager?.completeDismissal()

            }

        case .changed:

            guard !isFinished else {
                return
            }

            let translation = gestureRecognizer.translation(in: contentView)
            let verticalTranslation = translation.y
            isFinished = false

            guard (verticalTranslation > 0) && isInteractionInProgress else {
                update(0)
                updateCardViews(forTranslation: translation)
                return
            }

            snapshotView?.transform = .identity

            let adaptativeTranslation = self.adaptativeTranslation(for: verticalTranslation, elasticThreshold: elasticThreshold)
            let newPercentage = (adaptativeTranslation / dismissThreshold) * trackScreenPercentage

            guard currentPercentage != newPercentage else {
                return
            }

            currentPercentage = newPercentage
            update(currentPercentage)

        case .cancelled, .failed:

            isInteractionInProgress = false

            if !isFinished {
                resetCardViews()
            }

            panGestureRecognizer?.isEnabled = true

        case .ended:

            guard isInteractionInProgress else {
                resetCardViews()
                isFinished = false
                return
            }

            isInteractionInProgress = false

            let translation = gestureRecognizer.translation(in: contentView).y

            if translation >= dismissThreshold {
                isFinished = true
                finish()
            } else {
                resetCardViews()
                cancel()
                isFinished = false
            }

        default:
            break
        }

    }

    // MARK: - Math

    // Source: https://github.com/HarshilShah/DeckTransition
    let elasticTranslationCurve = { (translation: CGFloat, translationFactor: CGFloat) -> CGFloat in
        return 30 * atan(translation/120) + translation/10
    }

    private func adaptativeTranslation(for translation: CGFloat, elasticThreshold: CGFloat) -> CGFloat {

        let translationFactor: CGFloat = 2/3

        if translation >= elasticThreshold {
            let frictionLength = translation - elasticThreshold
            let frictionTranslation = elasticTranslationCurve(frictionLength, translationFactor)
            return frictionTranslation + (elasticThreshold * translationFactor)
        } else {
            return translation * translationFactor
        }

    }

    private func transform(forTranslation translation: CGPoint) -> CGAffineTransform {

        let translationFactor: CGFloat = 1/3
        var adaptedTranslation = translation

        // Vertical

        if translation.y < 0 || !(isInteractionInProgress) {
            adaptedTranslation.y = elasticTranslationCurve(translation.y, translationFactor)
        }

        let yTransform = adaptedTranslation.y * translationFactor

        if viewController.traitCollection.horizontalSizeClass == .compact {
            return CGAffineTransform(translationX: 0, y: yTransform)
        }

        // Horizontal

        adaptedTranslation.x = elasticTranslationCurve(translation.x, translationFactor)
        let xTransform = adaptedTranslation.x * translationFactor

        return CGAffineTransform(translationX: xTransform, y: yTransform)

    }

    // MARK: - Position Management

    private func updateCardViews(forTranslation translation: CGPoint) {

        let transform = self.transform(forTranslation: translation)

        snapshotView?.transform = transform
        contentView.transform = transform
        activityIndicatorView.transform = transform

    }

    private func resetCardViews() {

        let options = UIView.AnimationOptions(rawValue: 6 << 7)

        let animations = {
            self.snapshotView?.transform = .identity
            self.contentView.transform = .identity
            self.activityIndicatorView.transform = .identity
        }

        viewController.backgroundView.show()

        UIView.animate(withDuration: 0.15, delay: 0, options: options, animations: animations) { _ in
            self.update(0)
            self.cancel()
        }

    }

    // MARK: - Cancellation

    /**
     * Resets the view if needed.
     */

    func cancelIfNeeded() {

        if panGestureRecognizer?.state == .changed {
            panGestureRecognizer?.isEnabled = false
        }

    }

}
