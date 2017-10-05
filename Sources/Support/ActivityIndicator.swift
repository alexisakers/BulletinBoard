/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
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

    func startAnimating() {
        activityIndicatorView.startAnimating()
    }

    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }

    var color: UIColor? {
        get {
            return activityIndicatorView.color
        }
        set {
            activityIndicatorView.color = newValue
        }
    }

    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle {
        get {
            return activityIndicatorView.activityIndicatorViewStyle
        }
        set {
            activityIndicatorView.activityIndicatorViewStyle = newValue
        }
    }

}

