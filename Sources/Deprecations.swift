/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import Foundation

@available(*, unavailable, renamed: "BLTNItem")
@objc protocol BulletinItem {}

@available(*, unavailable, renamed: "BLTNItemManager")
@objc public class BulletinManager: NSObject {}

@available(*, unavailable, renamed: "BLTNActionItem")
@objc class ActionBulletinItem: NSObject {}

@available(*, unavailable, renamed: "BLTNPageItem")
@objc class PageBulletinItem: NSObject {}

@available(*, unavailable, message: "To specify the appearance, use BLTNItemAppearance. To create standard views, use BLTNInterfaceBuilder.")
@objc class BulletinInterfaceFactory: NSObject {}

@available(*, unavailable, renamed: "BLTNSpacing")
@objc class BulletinPadding: NSObject {}

@available(*, unavailable, renamed: "BLTNBackgroundViewStyle")
@objc class BulletinBackgroundViewStyle: NSObject {}
