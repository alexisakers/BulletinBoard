/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A presentation controller that displays a dimming view behing the top most view controller.
 */

class DimmingPresentationController: UIPresentationController {

    fileprivate var backgroundStyle: BulletinBackgroundViewStyle = .dimmed

    // MARK: - Background View

    fileprivate enum BackgroundView {

        case dim(UIView)
        case blur(UIVisualEffectView, UIBlurEffect)

        var instance: UIView {
            switch self {
            case .dim(let dimmingView):
                return dimmingView
            case .blur(let blurView, _):
                return blurView
            }
        }

    }

    fileprivate lazy var backgroundView: BackgroundView = {

        switch self.backgroundStyle {
        case .dimmed:

            let dimmingView = UIView()
            dimmingView.translatesAutoresizingMaskIntoConstraints = false
            dimmingView.alpha = 0.0
            dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)

            return .dim(dimmingView)

        case .blurred(let style):

            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: nil)
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false

            return .blur(blurEffectView, blurEffect)

        }

    }()

    // MARK: - Initialization

    convenience init(presentedViewController: UIViewController,
                     presenting presentingViewController: UIViewController?,
                     style: BulletinBackgroundViewStyle?) {
        
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        if let style = style {
            self.backgroundStyle = style
        }

    }

    // MARK: - Transitions

    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView!.frame
    }

    override func presentationTransitionWillBegin() {

        let rawBackgroundView = backgroundView.instance
        containerView?.insertSubview(rawBackgroundView, at: 0)

        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|",
                                           options: [], metrics: nil, views: ["backgroundView": rawBackgroundView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundView]|",
                                           options: [], metrics: nil, views: ["backgroundView": rawBackgroundView]))

        let presentationTransition = {

            switch self.backgroundView {
            case .dim(let dimmingView):
                dimmingView.alpha = 1.0

            case .blur(let blurView, let blurEffect):
                blurView.effect = blurEffect
            }

        }

        guard let coordinator = presentedViewController.transitionCoordinator else {
            presentationTransition()
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            presentationTransition()
        })

    }

    override func dismissalTransitionWillBegin() {

        let dismissalTransition = {

            switch self.backgroundView {
            case .dim(let dimmingView):
                dimmingView.alpha = 0.0

            case .blur(let blurView, _):
                blurView.effect = nil
            }

        }

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dismissalTransition()
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            dismissalTransition()
        }, completion: { _ in
            self.backgroundView.instance.removeFromSuperview()
        })

    }

}
