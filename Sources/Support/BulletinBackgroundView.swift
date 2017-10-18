/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * The view to display behind the bulletin.
 */

class BulletinBackgroundView: UIView {

    let style: BulletinBackgroundViewStyle

    // MARK: - Content View

    enum ContentView {

        case dim(UIView, CGFloat)
        case blur(UIVisualEffectView, UIBlurEffect)

        var instance: UIView {
            switch self {
            case .dim(let dimmingView, _):
                return dimmingView
            case .blur(let blurView, _):
                return blurView
            }
        }

    }

    private(set) var contentView: ContentView!

    // MARK: - Initialization

    init(style: BulletinBackgroundViewStyle) {
        self.style = style
        super.init(frame: .zero)
        initialize()
    }

    override init(frame: CGRect) {
        style = .dimmed
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        style = .dimmed
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {

        translatesAutoresizingMaskIntoConstraints = false

        func makeDimmingView() -> UIView {

            let dimmingView = UIView()
            dimmingView.alpha = 0.0
            dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            dimmingView.translatesAutoresizingMaskIntoConstraints = false

            return dimmingView

        }

        switch style {
        case .none:

            let dimmingView = makeDimmingView()

            addSubview(dimmingView)
            contentView = .dim(dimmingView, 0.0)

        case .dimmed:

            let dimmingView = makeDimmingView()

            addSubview(dimmingView)
            contentView = .dim(dimmingView, 1.0)

        case .blurred(let blurredBackground):

            let blurEffect = UIBlurEffect(style: blurredBackground.style)
            let blurEffectView = UIVisualEffectView(effect: nil)
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false

            addSubview(blurEffectView)
            contentView = .blur(blurEffectView, blurEffect)

        }

        let contentViewInstance = contentView.instance

        contentViewInstance.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentViewInstance.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentViewInstance.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentViewInstance.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    }

    // MARK: - Interactions

    /// Shows the background view. Animatable.
    func show() {

        switch contentView! {
        case .dim(let dimmingView, let maxAlpha):
            dimmingView.alpha = maxAlpha

        case .blur(let blurView, let blurEffect):
            blurView.effect = blurEffect
        }

    }

    /// Hides the background view. Animatable.
    func hide() {

        switch contentView! {
        case .dim(let dimmingView, _):
            dimmingView.alpha = 0

        case .blur(let blurView, _):
            blurView.effect = nil
        }

    }

}
