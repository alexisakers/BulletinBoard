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
     * The background is covered with a semi-transparent view. Similar to the view displayed behind
     * UIKit alerts and action sheets.
     */

    case dimmed

    /**
     * The background is blurred with the specified effect.
     * - parameter style: The style of blur to use to cover the background.
     */

    case blurred(style: UIBlurEffectStyle)

    // MARK: - Convenience

    /// The background blurred with a light style.
    public static let blurredLight: BulletinBackgroundViewStyle = .blurred(style: .light)

    /// The background blurred with an extra light style.
    public static let blurredExtraLight: BulletinBackgroundViewStyle = .blurred(style: .extraLight)

    /// The background blurred with a dark style.
    public static let blurredDark: BulletinBackgroundViewStyle = .blurred(style: .dark)

}
