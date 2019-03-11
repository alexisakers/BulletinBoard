/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * The types of background used to cover the content behind the bulletins.
 */

@objc public class BLTNBackgroundViewStyle: NSObject {

    enum Style {
        case none
        case dimmed
        case blurred(style: UIBlurEffect.Style, isDark: Bool)

        /// Whether the style is dark.
        var isDark: Bool {
            switch self {
            case .none, .dimmed: return true
            case .blurred(_, let isDarkBlur): return isDarkBlur
            }
        }

    }

    /// The internal style value.
    let rawValue: Style

    init(rawValue: Style) {
        self.rawValue = rawValue
    }

    @available(*, unavailable, message: "Use one of the presets to create a backrgound style object.")
    override init() {
        fatalError("BLTNBackgroundViewStyle.init is unavailable. Use one of the presets instead.")
    }

}

// MARK: - Presets

extension BLTNBackgroundViewStyle {

    /**
     * The background content is not covered.
     */

    @objc public static var none: BLTNBackgroundViewStyle {
        return BLTNBackgroundViewStyle(rawValue: .none)
    }

    /**
     * The background is covered with a semi-transparent view similar to the view displayed behind
     * UIKit alerts and action sheets.
     */

    @objc public static var dimmed: BLTNBackgroundViewStyle {
        return BLTNBackgroundViewStyle(rawValue: .dimmed)
    }

    /**
     * The background is blurred with the specified effect.
     *
     * Available on iOS 10.0 and later.
     *
     * - parameter style: The style of blur to use to cover the background.
     * - parameter isDark: Whether the blur effect is dark.
     */

    @objc public static func blurred(style: UIBlurEffect.Style, isDark: Bool) -> BLTNBackgroundViewStyle {
        return BLTNBackgroundViewStyle(rawValue: .blurred(style: style, isDark: isDark))
    }

    /// The background blurred with a light style.
    @objc public static var blurredLight: BLTNBackgroundViewStyle {
        return .blurred(style: .light, isDark: false)
    }

    /// The background blurred with an extra light style.
    @objc public static var blurredExtraLight: BLTNBackgroundViewStyle {
        return .blurred(style: .extraLight, isDark: false)
    }

    /// The background blurred with a dark style.
    @objc public static var blurredDark: BLTNBackgroundViewStyle {
        return .blurred(style: .dark, isDark: true)
    }

}
