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
            transitionContext.completeTransition(false)
            return
        }

        let rootView = fromVC.view!
        let contentView = fromVC.contentView
        let backgroundView = fromVC.backgroundView!
        let activityIndicatorView = fromVC.activityIndicator
        let snapshotActivityIndicator = ActivityIndicator()
        snapshotActivityIndicator.startAnimating()

        // Take Snapshot

        guard let snapshot = contentView.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(false)
            return
        }

        snapshotActivityIndicator.translatesAutoresizingMaskIntoConstraints = false

        snapshot.addSubview(snapshotActivityIndicator)
        snapshotActivityIndicator.topAnchor.constraint(equalTo: snapshot.topAnchor).isActive = true
        snapshotActivityIndicator.leftAnchor.constraint(equalTo: snapshot.leftAnchor).isActive = true
        snapshotActivityIndicator.rightAnchor.constraint(equalTo: snapshot.rightAnchor).isActive = true
        snapshotActivityIndicator.bottomAnchor.constraint(equalTo: snapshot.bottomAnchor).isActive = true

        snapshotActivityIndicator.style = .whiteLarge
        snapshotActivityIndicator.color = .black
        snapshotActivityIndicator.isUserInteractionEnabled = false

        snapshotActivityIndicator.alpha = activityIndicatorView.alpha

        rootView.insertSubview(snapshot, aboveSubview: contentView)
        snapshot.frame = contentView.frame
        contentView.isHidden = true
        activityIndicatorView.isHidden = true

        fromVC.prepareForDismissal(displaying: snapshot)

        // Animate dismissal

        let duration = transitionDuration(using: transitionContext)
        let options = UIView.AnimationOptions(rawValue: 6 << 16)

        let animations = {
            snapshot.frame.origin.y = rootView.frame.maxY + 12
            backgroundView.hide()
        }

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations) { finished in

            let isCancelled = transitionContext.transitionWasCancelled

            if !isCancelled {
                fromVC.view.removeFromSuperview()
            } else {
                contentView.isHidden = false
                activityIndicatorView.isHidden = false
                snapshot.removeFromSuperview()
            }

            transitionContext.completeTransition(!isCancelled)

        }

    }

}
