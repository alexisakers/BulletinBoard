import UIKit

/**
 * The animation controller for bulletin dismissal.
 *
 * It moves the card out of the screen, fades out the background view and removes it from the hierarchy
 * on completion.
 */

class BulletinDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from) as? BulletinViewController else {
            return
        }

        let rootView = fromVC.view!
        let contentView = fromVC.contentView
        let backgroundView = fromVC.backgroundView!

        // Animate dismissal

        let duration = transitionDuration(using: transitionContext)
        let options = UIViewAnimationOptions(rawValue: 6 << 16)

        rootView.layoutIfNeeded()
        contentView.layoutIfNeeded()
        backgroundView.layoutIfNeeded()

        let animations = {
            fromVC.layoutForDismissal()
            backgroundView.hide()
        }

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations) { finished in

            let isCancelled = transitionContext.transitionWasCancelled

            if !isCancelled {
                fromVC.view.removeFromSuperview()
            } else {
                fromVC.layoutForPresentation()
            }

            transitionContext.completeTransition(!isCancelled)

        }

    }

}
