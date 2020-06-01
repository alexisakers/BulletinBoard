/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import Foundation

/**
 * Describes the position of a view inside of its parent container.
 */

@objc public enum BLTNViewPosition: Int {

    /// The view is centered in its parent container.
    case centered

    /// The view is pinned to the four edges of its parent container.
    case pinnedToEdges

}
