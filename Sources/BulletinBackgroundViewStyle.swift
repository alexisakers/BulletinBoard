/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * The types of background used to cover the content behind the bulletins.
 */

public enum BulletinBackgroundViewStyle {

    /**
     * The background content is not covered.
     */

    case none

    /**
     * The background is covered with a semi-transparent view similar to the view displayed behind
     * UIKit alerts and action sheets.
     */

    case dimmed

    /**
     * The background is blurred with the specified effect.
     *
     * Available on iOS 10.0 and later.
     *
     * - parameter style: The style of blur to use to cover the background.
     */

    @available(iOS 10, *)
    case blurred(style: UIBlurEffectStyle, isDark: Bool)

    
    // MARK: - Convenience

    /// The background blurred with a light style.
    @available(iOS 10, *)
    public static let blurredLight: BulletinBackgroundViewStyle = .blurred(style: .light, isDark: false)

    /// The background blurred with an extra light style.
    @available(iOS 10, *)
    public static let blurredExtraLight: BulletinBackgroundViewStyle = .blurred(style: .extraLight, isDark: false)

    /// The background blurred with a dark style.
    @available(iOS 10, *)
    public static let blurredDark: BulletinBackgroundViewStyle = .blurred(style: .dark, isDark: true)

    // MARK: - Properties

    /// Whether the background is dark.
    var isDark: Bool {

        switch self {
        case .none: return false
        case .dimmed: return true
        case .blurred(_, let isDark): return isDark
        }

    }

}
