/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A presentation controller that displays a dimming view behing the top most view controller.
 */

public enum BackgroundViewStyle {
    case dimmed
    case blurredLight
    case blurredExtraLight
    case blurredDark
}

class DimmingPresentationController: UIPresentationController {

    fileprivate var backgroundStyle: BackgroundViewStyle = .dimmed
    fileprivate lazy var dimmingView: UIView = {

        let dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.alpha = 0.0

        switch self.backgroundStyle {
            case .dimmed:
                dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            case .blurredLight:
                dimmingView.addSubview(DimmingPresentationController.bluredView(style: .light))
            case .blurredExtraLight:
                dimmingView.addSubview(DimmingPresentationController.bluredView(style: .extraLight))
            case .blurredDark:
                dimmingView.addSubview(DimmingPresentationController.bluredView(style: .dark))
        }
        
        return dimmingView

    }()

    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, style: BackgroundViewStyle?) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        if let backgroundViewStyle = style {
            self.backgroundStyle = backgroundViewStyle
        }
    }
    
    fileprivate static func bluredView(style: UIBlurEffectStyle) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    // MARK: - Transitions

    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView!.frame
    }

    override func presentationTransitionWillBegin() {

        containerView?.insertSubview(dimmingView, at: 0)

        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })

    }

    override func dismissalTransitionWillBegin() {

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })

    }

}
