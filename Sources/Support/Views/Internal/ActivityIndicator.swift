/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A view that contains an activity indicator. The indicator is centered inside the view.
 */

class ActivityIndicator: UIView {

    private let activityIndicatorView = UIActivityIndicatorView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicatorView)

        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    }

    // MARK: - Activity Indicator

    /// Starts the animation of the activity indicator.
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }

    /// Stops the animation of the activity indicator.
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }

    /// The color of the activity indicator.
    var color: UIColor? {
        get {
            return activityIndicatorView.color
        }
        set {
            activityIndicatorView.color = newValue
        }
    }

    /// The style of the activity indicator.
    var style: UIActivityIndicatorView.Style {
        get {
            return activityIndicatorView.style
        }
        set {
            activityIndicatorView.style = newValue
        }
    }

}
