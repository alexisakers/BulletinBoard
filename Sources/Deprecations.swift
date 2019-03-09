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

@available(*, unavailable, renamed: "BLTNViewController")
@objc public class BLTNItemManager: NSObject {}

extension BLTNActionItem {

    @available(*, unavailable, renamed: "parent")
    @objc public var manager: BLTNViewController? {
        return parent
    }

}

extension BLTNActionItem {

    @available(*, unavailable, renamed: "didPresentHandler")
    @objc public var presentationHandler: ((BLTNItem) -> Void)? {
        get { fatalError("BLTNItem.presentationHandler is removed. Use didPresentHandler instead.") }
        set { fatalError("BLTNItem.presentationHandler is removed. Use didPresentHandler instead.") }
    }

    @available(*, unavailable, renamed: "didDismissHandler")
    @objc public var dismissalHandler: ((BLTNItem) -> Void)? {
        get { fatalError("BLTNItem.dismissalHandler is removed. Use didDismissHandler instead.") }
        set { fatalError("BLTNItem.dismissalHandler is removed. Use didDismissHandler instead.") }
    }

    @available(*, unavailable, renamed: "actionTitle")
    @objc public var actionButtonTitle: String? {
        get { fatalError("BLTNItem.actionButtonTitle is removed. Use actionTitle instead.") }
        set { fatalError("BLTNItem.actionButtonTitle is removed. Use actionTitle instead.") }
    }

    @available(*, unavailable, renamed: "alternateActionTitle")
    @objc public var alternativeButtonTitle: String? {
        get { fatalError("BLTNItem.alternativeButtonTitle is removed. Use alternateActionTitle instead.") }
        set { fatalError("BLTNItem.alternativeButtonTitle is removed. Use alternateActionTitle instead.") }
    }

    @available(*, unavailable, renamed: "alternateActionHandler")
    @objc public var alternativeHandler: ((BLTNItem) -> Void)? {
        get { fatalError("BLTNItem.alternativeHandler is removed. Use alternateActionHandler instead.") }
        set { fatalError("BLTNItem.alternativeHandler is removed. Use alternateActionHandler instead.") }
    }

    @available(*, unavailable, renamed: "alternateActionButtonTapped(sender:)")
    @objc(alternativeButtonTappedWithSender:)
    public func alternativeButtonTapped(sender: UIButton) {
        fatalError("BLTNItem.alternativeButtonTapped is removed. Use alternateActionButtonTapped instead.")
    }

    @available(*, unavailable, renamed: "alternateActionButton")
    @objc public var alternativeButton: UIButton {
        get { fatalError("BLTNItem.alternativeButton is removed. Use alternativeButton instead.") }
    }

}
