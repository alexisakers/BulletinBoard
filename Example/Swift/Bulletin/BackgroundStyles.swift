import UIKit
import BulletinBoard

/**
 * Returns a list of all the background styles.
 */

func BackgroundStyles() -> [(name: String, style: BulletinBackgroundViewStyle)] {

    var styles: [(name: String, style: BulletinBackgroundViewStyle)] = [
        ("None", .none),
        ("Dimmed", .dimmed)
    ]

    if #available(iOS 10, *) {
        styles.append(("Extra Light", .blurredExtraLight))
        styles.append(("Light", .blurredLight))
        styles.append(("Dark", .blurredDark))
        styles.append(("Extra Dark", .blurred(style: UIBlurEffectStyle(rawValue: 3)!, isDark: true)))
    }

    return styles

}
