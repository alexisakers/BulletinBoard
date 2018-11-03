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

        var isDark: Bool {

            switch self {
            case .none, .dimmed: return true
            case .blurred(_, let isDarkBlur): return isDarkBlur
            }

        }

    }

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

    @objc public static let none = BLTNBackgroundViewStyle(rawValue: .none)

    /**
     * The background is covered with a semi-transparent view similar to the view displayed behind
     * UIKit alerts and action sheets.
     */

    @objc public static let dimmed = BLTNBackgroundViewStyle(rawValue: .dimmed)

    /**
     * The background is blurred with the specified effect.
     *
     * Available on iOS 10.0 and later.
     *
     * - parameter style: The style of blur to use to cover the background.
     * - parameter isDark: Whether the blur effect is dark.
     */

    @available(iOS 10, *)
    @objc public static func blurred(style: UIBlurEffect.Style, isDark: Bool) -> BLTNBackgroundViewStyle {
        return BLTNBackgroundViewStyle(rawValue: .blurred(style: style, isDark: isDark))
    }

    /// The background blurred with a light style.
    @available(iOS 10, *)
    @objc public static let blurredLight: BLTNBackgroundViewStyle = .blurred(style: .light, isDark: false)

    /// The background blurred with an extra light style.
    @available(iOS 10, *)
    @objc public static let blurredExtraLight: BLTNBackgroundViewStyle = .blurred(style: .extraLight, isDark: false)

    /// The background blurred with a dark style.
    @available(iOS 10, *)
    @objc public static let blurredDark: BLTNBackgroundViewStyle = .blurred(style: .dark, isDark: true)

}
