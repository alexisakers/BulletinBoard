/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

@available(*, unavailable, renamed: "BLTNItem")
@objc public protocol BulletinItem {}

@available(*, unavailable, renamed: "BLTNItemManager")
@objc public class BulletinManager: NSObject {}

@available(*, unavailable, renamed: "BLTNActionItem")
@objc public class ActionBulletinItem: NSObject {}

@available(*, unavailable, renamed: "BLTNPageItem")
@objc public class PageBulletinItem: NSObject {}

@available(*, unavailable, message: "To specify the appearance, use BLTNItemAppearance. To create standard views, use BLTNInterfaceBuilder.")
@objc public class BulletinInterfaceFactory: NSObject {}

@available(*, unavailable, renamed: "BLTNSpacing")
@objc public class BulletinPadding: NSObject {}

@available(*, unavailable, renamed: "BLTNBackgroundViewStyle")
@objc public class BulletinBackgroundViewStyle: NSObject {}

@available(*, unavailable, renamed: "BLTNHighlightButtonWrapper")
@objc public class HighlightButtonWrapper: UIView {}
