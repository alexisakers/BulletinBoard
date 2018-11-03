/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * The animation controller for bulletin presentation.
 *
 * It moves the card on screen, creates and fades in the background view.
 */

class BulletinPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    let style: BLTNBackgroundViewStyle

    init(style: BLTNBackgroundViewStyle) {
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

        containerView.addSubview(rootView)

        // Prepare background view

        rootView.insertSubview(backgroundView, at: 0)
        backgroundView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true

        rootView.setNeedsLayout()
        contentView.setNeedsLayout()

        rootView.layoutIfNeeded()
        contentView.layoutIfNeeded()
        backgroundView.layoutIfNeeded()

        // Animate presentation

        let duration = transitionDuration(using: transitionContext)
        let options = UIView.AnimationOptions(rawValue: 7 << 16)

        let animations = {
            toVC.moveIntoPlace()
            backgroundView.show()
        }

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }

}
