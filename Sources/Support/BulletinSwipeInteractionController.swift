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
    private var contentView: UIView!
    private var currentPercentage: CGFloat = -1

    private weak var viewController: BulletinViewController!

    // MARK: - Preparation

    /**
     * Sets up the interaction recognizer for the given view controller and content view.
     */

    func wire(to viewController: BulletinViewController) {
        self.viewController = viewController
        self.contentView = viewController.contentView
        prepareGestureRecognizer()
    }

    func prepareGestureRecognizer() {

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

        let dismissThreshold: CGFloat = 240
        let elasticThreshold: CGFloat = 120

        switch gestureRecognizer.state {
        case .began:

            isFinished = false

            gestureRecognizer.setTranslation(.zero, in: contentView)

            guard viewController.isDismissable else {
                isInteractionInProgress = false
                return
            }

            isInteractionInProgress = true
            viewController.dismiss(animated: true, completion: nil)

        case .changed:

            let translation = gestureRecognizer.translation(in: contentView).y

            guard !isFinished else {
                return
            }

            isFinished = false

            guard (translation > 0) && isInteractionInProgress else {
                update(0)
                updateContentView(forVerticalTranslation: translation)
                return
            }

            contentView.transform = .identity

            guard translation <= dismissThreshold else {
                isFinished = true
                isInteractionInProgress = false
                finish()
                return
            }

            let adaptativeTranslation = self.adaptativeTranslation(for: translation, elasticThreshold: elasticThreshold)
            let trackScreenPercentage = dismissThreshold / viewController.view.bounds.height
            let newPercentage = (adaptativeTranslation / dismissThreshold) * (2.2 * trackScreenPercentage)

            guard currentPercentage != newPercentage else {
                return
            }

            currentPercentage = newPercentage
            update(currentPercentage)

        case .cancelled, .failed:
            isInteractionInProgress = false

            if !isFinished {
                resetContentView()
            }

        case .ended:

            isInteractionInProgress = false

            if !isFinished {
                resetContentView()
                cancel()
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

        let translationFactor: CGFloat = 1/2

        if translation >= elasticThreshold {
            let frictionLength = translation - elasticThreshold
            let frictionTranslation = elasticTranslationCurve(frictionLength, translationFactor)
            return frictionTranslation + (elasticThreshold * translationFactor)
        } else {
            return translation * translationFactor
        }

    }

    private func transform(forVerticalTranslation translation: CGFloat) -> CGFloat {

        let translationFactor: CGFloat = 1/2
        var adaptedTranslation = translation

        if translation < 0 || !(viewController.isDismissable) {
            adaptedTranslation = elasticTranslationCurve(translation, translationFactor)
        }

        return adaptedTranslation * translationFactor

    }

    // MARK: - Position Management

    private func updateContentView(forVerticalTranslation translation: CGFloat) {
        let yTransform = transform(forVerticalTranslation: translation)
        contentView.transform = CGAffineTransform(translationX: 0, y: yTransform)
    }

    private func resetContentView() {

        let options: UIViewAnimationOptions = [.allowAnimatedContent, .curveLinear]

        let animations = {
            self.contentView.transform = .identity
        }

        self.viewController.backgroundView.show()

        UIView.animate(withDuration: 0.15, delay: 0, options: options, animations: animations) { _ in
            self.cancel()
        }

    }

}
