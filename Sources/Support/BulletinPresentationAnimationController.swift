/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * The animation controller for bulletin presentation.
 *
 * It moves the card on screen, creates and fades in the background view.
 */

class BulletinPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    let style: BulletinBackgroundViewStyle

    init(style: BulletinBackgroundViewStyle) {
        self.style = style
    }

    // MARK: - Transition

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toVC = transitionContext.viewController(forKey: .to) as? BulletinViewController else {
            return
        }

        let rootView = toVC.view!
        let contentView = toVC.contentView
        let backgroundView = toVC.backgroundView!
        let containerView = transitionContext.containerView

        // Add root view

        rootView.frame = containerView.frame
        rootView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(rootView)

        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[rootView]|",
                                           options: [], metrics: nil, views: ["rootView": rootView])
        )

        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[rootView]|",
                                           options: [], metrics: nil, views: ["rootView": rootView])
        )

        // Prepare background view

        rootView.insertSubview(backgroundView, at: 0)

        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|",
                                           options: [], metrics: nil, views: ["backgroundView": backgroundView])
        )

         NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundView]|",
                                           options: [], metrics: nil, views: ["backgroundView": backgroundView])
        )

        rootView.layoutIfNeeded()
        contentView.layoutIfNeeded()
        backgroundView.layoutIfNeeded()

        // Animate presentation

        let duration = transitionDuration(using: transitionContext)
        let options = UIViewAnimationOptions(rawValue: 7 << 16)

        let animations = {

            toVC.moveIntoPlace()
            backgroundView.show()
            toVC.showBottomSafeAreaCover()
            
        }

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }

}
