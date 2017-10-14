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

        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }

        guard let backgroundView = transitionContext.containerView.subviews.first(where: { $0 is BulletinBackgroundView }) as? BulletinBackgroundView else {
            return
        }

        let duration = transitionDuration(using: transitionContext)
        let options: UIViewAnimationOptions = [UIViewAnimationOptions.allowAnimatedContent, .beginFromCurrentState, .curveLinear]

        let animations = {

            fromVC.view.frame.origin.y = fromVC.view.frame.maxY

            switch backgroundView.contentView! {
            case .dim(let dimmingView, _):
                dimmingView.alpha = 0

            case .blur(let blurView, _):
                blurView.effect = nil
            }

        }

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations) { finished in

            let cancelled = transitionContext.transitionWasCancelled

            if !cancelled {
                backgroundView.removeFromSuperview()
            } else {

                switch backgroundView.contentView! {
                case .dim(let dimmingView, _):
                    dimmingView.alpha = 1

                case .blur(let blurView, let effect):
                    blurView.effect = effect
                }

            }

            transitionContext.completeTransition(!cancelled)

        }

    }

}
