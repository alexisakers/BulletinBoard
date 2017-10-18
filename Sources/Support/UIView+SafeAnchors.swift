import UIKit

// Source: https://gist.github.com/HarshilShah/6d75593d4c78a8015f54a090b115a40b

extension UIView {

    var safeTopAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideWithFallback?.topAnchor ?? topAnchor }
    var safeBottomAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideWithFallback?.bottomAnchor ?? bottomAnchor }

    var safeLeadingAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideWithFallback?.leadingAnchor ?? leadingAnchor }
    var safeTrailingAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideWithFallback?.trailingAnchor ?? trailingAnchor }

    var safeCenterXAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideWithFallback?.centerXAnchor ?? centerXAnchor }
    var safeCenterYAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideWithFallback?.centerYAnchor ?? centerYAnchor }

    var safeWidthAnchor: NSLayoutDimension { return safeAreaLayoutGuideWithFallback?.widthAnchor ?? widthAnchor }
    var safeHeightAnchor: NSLayoutDimension { return safeAreaLayoutGuideWithFallback?.heightAnchor ?? heightAnchor }

    private var safeAreaLayoutGuideWithFallback: UILayoutGuide? {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide
        } else {
            return nil
        }
    }

}
