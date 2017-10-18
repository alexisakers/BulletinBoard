/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * An interaction controller that handles swipe-to-dismiss for bulletins.
 */

class BulletinSwipeInteractionController: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {

    /// Whether a panning interaction is in progress.
    var isInteractionInProgress = false

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

            guard viewController.isDismissable else {
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

            let translation = gestureRecognizer.translation(in: contentView).y

            guard !isFinished else {
                return
            }

            isFinished = false

            guard (translation > 0) && isInteractionInProgress else {
                update(0)
                updateCardViews(forVerticalTranslation: translation)
                return
            }

            snapshotView?.transform = .identity

            guard translation <= dismissThreshold else {
                isFinished = true
                isInteractionInProgress = false
                finish()
                return
            }

            let adaptativeTranslation = self.adaptativeTranslation(for: translation, elasticThreshold: elasticThreshold)
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

        case .ended:

            isInteractionInProgress = false

            if !isFinished {
                resetCardViews()
                cancel()
            }

            isFinished = false
 
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

    private func transform(forVerticalTranslation translation: CGFloat) -> CGAffineTransform {

        let translationFactor: CGFloat = 1/3
        var adaptedTranslation = translation

        if translation < 0 || !(viewController.isDismissable) {
            adaptedTranslation = elasticTranslationCurve(translation, translationFactor)
        }

        let yTransform = adaptedTranslation * translationFactor
        return CGAffineTransform(translationX: 0, y: yTransform)

    }

    // MARK: - Position Management

    private func updateCardViews(forVerticalTranslation translation: CGFloat) {

        let transform = self.transform(forVerticalTranslation: translation)

        snapshotView?.transform = transform
        contentView.transform = transform

    }

    private func resetCardViews() {

        let options: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: 6 << 7)

        let animations = {
            self.snapshotView?.transform = .identity
            self.contentView.transform = .identity
        }

        viewController.backgroundView.show()
        viewController.showBottomSafeAreaCover()

        UIView.animate(withDuration: 0.15, delay: 0, options: options, animations: animations) { _ in
            self.update(0)
            self.cancel()
        }

    }

}
