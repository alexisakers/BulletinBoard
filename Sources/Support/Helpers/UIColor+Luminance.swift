/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

extension UIColor {

    var luminance: CGFloat {

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return 0.2126 * red + 0.7152 * green + 0.0722 * blue

    }

    var needsDarkText: Bool {
        return luminance > sqrt(1.05 * 0.05) - 0.05
    }

}
