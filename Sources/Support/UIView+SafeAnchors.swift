import UIKit

// Source: https://gist.github.com/HarshilShah/6d75593d4c78a8015f54a090b115a40b

extension UIView {

    var safeTopAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideWithFallback.topAnchor }
    var safeBottomAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideWithFallback.bottomAnchor }

    var safeLeftAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideWithFallback.leftAnchor }
    var safeRightAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideWithFallback.rightAnchor }

    var safeLeadingAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideWithFallback.leadingAnchor }
    var safeTrailingAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideWithFallback.trailingAnchor }

    var safeCenterXAnchor: NSLayoutXAxisAnchor { return safeAreaLayoutGuideWithFallback.centerXAnchor }
    var safeCenterYAnchor: NSLayoutYAxisAnchor { return safeAreaLayoutGuideWithFallback.centerYAnchor }

    var safeWidthAnchor: NSLayoutDimension { return safeAreaLayoutGuideWithFallback.widthAnchor }
    var safeHeightAnchor: NSLayoutDimension { return safeAreaLayoutGuideWithFallback.heightAnchor }

    private var safeAreaLayoutGuideWithFallback: UILayoutGuide {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide
        } else {
            return layoutMarginsGuide
        }
    }

}
