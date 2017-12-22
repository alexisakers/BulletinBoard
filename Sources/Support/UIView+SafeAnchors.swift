import UIKit

// Source: https://gist.github.com/HarshilShah/6d75593d4c78a8015f54a090b115a40b

extension UIView {

    var safeTopAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideIfAvailable?.topAnchor ?? topAnchor }
    var safeBottomAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideIfAvailable?.bottomAnchor ?? bottomAnchor }

    var safeLeadingAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideIfAvailable?.leadingAnchor ?? leadingAnchor }
    var safeTrailingAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideIfAvailable?.trailingAnchor ?? trailingAnchor }

    var safeCenterXAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideIfAvailable?.centerXAnchor ?? centerXAnchor }
    var safeCenterYAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideIfAvailable?.centerYAnchor ?? centerYAnchor }

    var safeWidthAnchor: NSLayoutDimension { return safeAreaLayoutGuideIfAvailable?.widthAnchor ?? widthAnchor }
    var safeHeightAnchor: NSLayoutDimension { return safeAreaLayoutGuideIfAvailable?.heightAnchor ?? heightAnchor }

    private var safeAreaLayoutGuideIfAvailable: UILayoutGuide? {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide
        } else {
            return nil
        }
    }

}
