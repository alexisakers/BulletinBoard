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
        containerView.addSubview(rootView)

        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        rootView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        rootView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        rootView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

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
