/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;

@class BLTNItemManager;

/**
 * An item that can be displayed inside a bulletin card.
 */

@protocol BLTNItem <NSObject>

#pragma mark - Configuration

/**
 * The current object managing the item.
 *
 * This property is set when the item is currently being displayed. It will be set to `nil` when
 * the item is removed from view.
 *
 * When implementing `BLTNItem`, you should mark this property `weak` to avoid retain cycles.
 */

@property (nonatomic, nullable, weak) BLTNItemManager *manager;

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
 * The default value is `true`. The user will be able to dismiss the bulletin by tapping on a button
 * in the corner of the screen.
 *
 * You should set it to `false` if the interface of the bulletin already has buttons to dismiss the item,
 * such as an action button.
 */

@property (nonatomic) BOOL requiresCloseButton;

/**
 * Whether the card should start with an activity indicator.
 *
 * Set this value to `false` to display the elements right away. If you set it to `true`,
 * you'll need to call `manager?.hideActivityIndicator()` to show the UI.
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
 * If you set this value, you'll be able to call `manager?.displayNextItem()` to push the next item to
 * the stack.
 */

@property (nonatomic, nullable, strong) id<BLTNItem> nextItem;

// MARK: - Interface

/**
 * Creates the list of views to display inside the bulletin card.
 *
 * The views will be arranged vertically, in the order they are stored in the return array.
 */

- (NSArray<UIView *> * _Nonnull)makeArrangedSubviews;

/**
 * Called by the manager when the item was added to the bulletin.
 *
 * Use this function to configure your managed views, and allocate any resources required
 * for this item.
 */

- (void)setUp;

/**
 * Called by the manager when the item was removed from the bulletin.
 *
 * Use this function to remove any button target or gesture recognizers from your managed views, and
 * deallocate any resources created for this item that are no longer needed.
 */

- (void)tearDown;
    
/**
* Called by the manager when bulletin item is about to be pushed onto the view.
*/
    
- (void)willDisplay;

/**
 * Called by the manager when bulletin item is pushed onto the view.
 */

- (void)onDisplay;

/**
 * Called by the manager when bulletin item is dismissed. This is called after the bulletin
 * is moved out of view.
 */

- (void)onDismiss;

@end
