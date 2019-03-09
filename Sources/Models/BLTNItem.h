/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;

@class BLTNViewController;

/**
 * An item that can be displayed inside a bulletin card.
 *
 * You don't use this class directly, but one of its subclasses. You need to override
 * `makeArrangedSubviews` in order to provide the list of views to display.
 */

@interface BLTNItem : NSObject

#pragma mark - Configuration

/**
 * The current view controller presenting the item.
 *
 * This property is set when the item is currently being displayed. It will be set to `nil` when
 * the item is removed from view.
 *
 * When implementing `BLTNItem`, you should mark this property as `weak` to avoid retain cycles.
 */

@property (nonatomic, nullable, weak) BLTNViewController *parent;

/**
 * Whether the page can be dismissed.
 *
 * If you set this value to `true`, the user will be able to dismiss the bulletin by tapping outside
 * of the card or by swiping down.
 *
 * You should set it to `true` for the last item you want to display, or for items that start an optional flow
 * (ex: a purchase).
 */

@property (nonatomic, getter=isDismissable) BOOL dismissable;

/**
 * Whether the page can be dismissed with a close button.
 *
 * The default value is `true`, the user will be able to dismiss the bulletin by tapping on a button
 * in the corner of the screen.
 */

@property (nonatomic) BOOL showsCloseButton;

/**
 * Whether the card should start with an activity indicator.
 *
 * Set this value to `false` to display the elements right away. If you set it to `true`,
 * you'll need to call `parent?.hideActivityIndicator()` to show the UI.
 */

@property (nonatomic) BOOL shouldStartWithActivityIndicator;

/**
 * Whether the item should move with the keyboard.
 *
 * You must set it to `true` if the item displays a text field. You can set it to `false` if you
 * don't want the bulletin to move when system alerts containing a text field (ex: iTunes login)
 * are displayed.
 */

@property (nonatomic) BOOL shouldRespondToKeyboardChanges;

/**
 * The item to display after this one.
 *
 * If you set this value, you'll be able to call `parent?.displayNextItem()` to push the next item to
 * the stack.
 */

@property (nonatomic, nullable, strong) BLTNItem *nextItem;

// MARK: - Interface

/**
 * Creates the list of views to display inside the bulletin card.
 *
 * The views will be arranged vertically, in the order they are stored in the return array.
 * @warning You need to override this method in your subclasses.
 */

- (NSArray<UIView *> * _Nonnull)makeArrangedSubviews;

/**
 * Called by the parent view controller when the item was added to the bulletin.
 *
 * Override this function to configure your managed views, and allocate any resources required
 * for this item. Make sure to call `super` if you override this method.
 */

- (void)setUp NS_REQUIRES_SUPER;

/**
 * Called by the parent view controller when the item was removed from the bulletin view.
 *
 * Override this method if elements you returned in `makeContentViews` need cleanup. Make sure
 * to call `super` if you override this method.
 *
 * This is an implementation detail of `BLTNItem` and you should not call it directly.
 */

- (void)tearDown NS_REQUIRES_SUPER;

/**
 * Called by the parent controller when the bulletin item is about to be presented.
 */

- (void)willPresent NS_REQUIRES_SUPER;

/**
 * Called by the parent view controller when the bulletin item is pushed onto the view.
 *
 * By default, this method calls the `presentationHandler` of the action item, if you are using a
 * `BLTNActionItem`. Override this method if you need to perform additional preparation after presentation
 * (although using `setUp` is preferred).
 */

- (void)didPresent NS_REQUIRES_SUPER;

/**
 * Called by the parent controller when the bulletin item is about to be dismissed.
 */

- (void)willDismiss NS_REQUIRES_SUPER;

/**
 * Called by the parent view controller when the bulletin item is dismissed. This is called after the bulletin
 * is moved out of view.
 *
 * By default, this method calls the `dismissalHandler` of the action item, if you are using a
 * `BLTNActionItem`. Override this method if you need to perform additional cleanup after dismissal
 * (although using `tearDown` is preferred).
 */

- (void)didDismiss NS_REQUIRES_SUPER;

@end
