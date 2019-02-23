import UIKit

// Source: https://gist.github.com/HarshilShah/6d75593d4c78a8015f54a090b115a40b

extension UIViewController {

    @nonobjc var safeTopAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideIfAvailable?.topAnchor ?? topLayoutGuide.bottomAnchor }

    @nonobjc var safeBottomAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideIfAvailable?.bottomAnchor ?? bottomLayoutGuide.bottomAnchor }

    @nonobjc private var safeAreaLayoutGuideIfAvailable: UILayoutGuide? {
        return view.safeAreaLayoutGuideIfAvailable
    }

}

extension UIView {

    @nonobjc var safeLeadingAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideIfAvailable?.leadingAnchor ?? leadingAnchor }
    @nonobjc var safeTrailingAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideIfAvailable?.trailingAnchor ?? trailingAnchor }

    @nonobjc var safeCenterXAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideIfAvailable?.centerXAnchor ?? centerXAnchor }
    @nonobjc var safeCenterYAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideIfAvailable?.centerYAnchor ?? centerYAnchor }

    @nonobjc var safeWidthAnchor: NSLayoutDimension { return safeAreaLayoutGuideIfAvailable?.widthAnchor ?? widthAnchor }
    @nonobjc var safeHeightAnchor: NSLayoutDimension { return safeAreaLayoutGuideIfAvailable?.heightAnchor ?? heightAnchor }

    @nonobjc fileprivate var safeAreaLayoutGuideIfAvailable: UILayoutGuide? {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide
        } else {
            return nil
        }
    }

}
