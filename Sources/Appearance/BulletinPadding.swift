/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * Represents a padding value.
 */

@objc public class BulletinPadding: NSObject {

    let rawValue: CGFloat

    init(rawValue: CGFloat) {
        self.rawValue = rawValue
    }

    /**
     * A custom padding.
     *
     * - parameter value: The spacing to apply.
     */

    @objc public class func custom(_ value: CGFloat) -> BulletinPadding {
        return BulletinPadding(rawValue: value)
    }

    /**
     * No padding is applied. (value: 0)
     *
     * If you use this padding, corner radii will be ignored.
     */

    @objc public class var none: BulletinPadding {
        return BulletinPadding(rawValue: 0)
    }

    /**
     * A compact padding. (value: 6)
     */

    @objc public class var compact: BulletinPadding {
        return BulletinPadding(rawValue: 6)
    }

    /**
     * The standard padding. (value: 12)
     */

    @objc public class var regular: BulletinPadding {
        return BulletinPadding(rawValue: 12)
    }

}
