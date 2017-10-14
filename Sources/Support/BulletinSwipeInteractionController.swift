import UIKit

/**
 * An interaction controller that handles swipe-to-dismiss for bulletins.
 */

class BulletinSwipeInteractionController: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {

    /// Whether a panning interaction is in progress.
    var isInteractionInProgress = false

    // MARK: - State

    private var isFinished = false
    private var viewController: BulletinViewController!
    private var contentView: UIView!

    private var currentPercentage: CGFloat = -1

    // MARK: - Preparation

    /**
     * Sets up the interaction recognizer for the given view controller and content view.
     */

    func wire(to viewController: BulletinViewController, contentView: UIView) {
        self.viewController = viewController
        self.contentView = contentView
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

            guard (translation > 0) && isInteractionInProgress else {
                isFinished = false

                if currentPercentage == -1 {
                    update(0)
                }

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

            isFinished = false

            let adaptativeTranslation = self.adaptativeTranslation(for: translation, elasticThreshold: elasticThreshold)
            let trackScreenPercentage = dismissThreshold / viewController.view.bounds.height
            let newPercentage = (adaptativeTranslation / dismissThreshold) * trackScreenPercentage

            guard newPercentage != currentPercentage else {
                return
            }

            currentPercentage = newPercentage
            update(currentPercentage)

        case .cancelled, .failed:
            isInteractionInProgress = false

            if !isFinished {
                resetContentView()
                cancel()
            }

        case .ended:

            isInteractionInProgress = false
            resetContentView()

            if !isFinished {
                resetContentView()
                cancel()
            }
 
        default:
            break
        }

    }

    // MARK: - Math

    let elasticCurve = { (translation: CGFloat, translationFactor: CGFloat) -> CGFloat in
        let frictionTranslation = 30 * atan(translation/120) + translation/10
        return frictionTranslation * translationFactor
    }

    private func adaptativeTranslation(for translation: CGFloat, elasticThreshold: CGFloat) -> CGFloat {

        let translationFactor: CGFloat = 1/2

        if translation >= elasticThreshold {
            let frictionLength = translation - elasticThreshold
            let frictionTranslation = 30 * atan(frictionLength/120) + frictionLength/10
            return frictionTranslation + (elasticThreshold * translationFactor)
        } else {
            return translation * translationFactor
        }

    }

    private func transform(forVerticalTranslation translation: CGFloat) -> CGFloat {

        let translationFactor: CGFloat = 1/2

        if translation < 0 || !(viewController.isDismissable) {
            return elasticCurve(translation, translationFactor)
        } else {
            return translation * translationFactor
        }

    }

    private func updateContentView(forVerticalTranslation translation: CGFloat) {
        let yTransform = transform(forVerticalTranslation: translation)
        contentView.transform = CGAffineTransform(translationX: 0, y: yTransform)
    }

    private func resetContentView() {

        guard contentView.transform != .identity else {
            return
        }

        let animations = {
            self.contentView.transform = .identity
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(rawValue: 7 << 16), animations: animations, completion: nil)

    }

}
