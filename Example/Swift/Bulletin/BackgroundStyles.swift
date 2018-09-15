import UIKit
import BLTNBoard

/**
 * Returns a list of all the background styles.
 */

func BackgroundStyles() -> [(name: String, style: BLTNBackgroundViewStyle)] {

    var styles: [(name: String, style: BLTNBackgroundViewStyle)] = [
        ("None", .none),
        ("Dimmed", .dimmed)
    ]

    if #available(iOS 10, *) {
        styles.append(("Extra Light", .blurredExtraLight))
        styles.append(("Light", .blurredLight))
        styles.append(("Dark", .blurredDark))
        styles.append(("Extra Dark", .blurred(style: UIBlurEffect.Style(rawValue: 3)!, isDark: true)))
    }

    return styles

}
