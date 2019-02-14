/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * The view to display behind the bulletin.
 */

class BulletinBackgroundView: UIView {

    var style: BLTNBackgroundViewStyle {
        didSet {
            reloadContentView()
        }
    }

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

    init(style: BLTNBackgroundViewStyle) {
        self.style = style
        super.init(frame: .zero)
        reloadContentView()
    }

    override init(frame: CGRect) {
        style = .dimmed
        super.init(frame: frame)
        reloadContentView()
    }

    required init?(coder aDecoder: NSCoder) {
        style = .dimmed
        super.init(coder: aDecoder)
        reloadContentView()
    }

    private func reloadContentView() {
        translatesAutoresizingMaskIntoConstraints = false

        func makeDimmingView() -> UIView {
            let dimmingView = UIView()
            dimmingView.alpha = 0.0
            dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            dimmingView.translatesAutoresizingMaskIntoConstraints = false
            return dimmingView
        }

        if let currentContentView = contentView {
            currentContentView.instance.removeFromSuperview()
        }

        switch style.rawValue {
        case .none:
            let dimmingView = makeDimmingView()
            contentView = .dim(dimmingView, 0.0)

        case .dimmed:
            let dimmingView = makeDimmingView()
            contentView = .dim(dimmingView, 1.0)

        case .blurred(let blurredBackground):
            let blurEffect = UIBlurEffect(style: blurredBackground.style)
            let blurEffectView = UIVisualEffectView(effect: nil)
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false
            contentView = .blur(blurEffectView, blurEffect)
        }

        let contentViewInstance = contentView.instance
        addSubview(contentViewInstance)

        NSLayoutConstraint.activate([
            contentViewInstance.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentViewInstance.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentViewInstance.topAnchor.constraint(equalTo: topAnchor),
            contentViewInstance.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
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
