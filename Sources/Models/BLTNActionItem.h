/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;

#import "BLTNItem.h"

@class BLTNItemManager;
@class BLTNItemAppearance;
@class BLTNInterfaceBuilder;

/**
 * A standard bulletin item with that displays a large action button and a smaller button for alternative options.
 *
 * You do not use this class directly:
 *
 * - If your custom item has a title and optional stock elements (description, image), use `BLTNPageItem`
 * which provides these stock elements. You can also override this class to insert custom views between the stock
 * views.
 *
 * - If you need to display custom elements with the standard buttons on a page without a title, subclass `BLTNActionItem`
 * and implement the `makeContentViews` method to return the elements to display above the buttons.
 *
 * Subclasses can override several methods to customize the UI:
 *
 * - In `footerViews`, return the views to display below the buttons.
 * - In `actionButtonTapped(sender:)` and `alternativeButtonTapped(sender:)`, perform custom additional button handling
 * (ex: haptic feedback).
 *
 * Use the `appearance` property to customize the appearance of the buttons. If you want to use a different interface
 * builder type, change the `InterfaceBuilderType` property.
 */

@interface BLTNActionItem : NSObject <BLTNItem>

#pragma mark - Page Contents

/**
 * The title of the action button. The action button represents the main action for the item.
 *
 * If you set this property to `nil`, no action button will be added (this is the default).
 */

@property (nonatomic, strong, nullable) NSString *actionButtonTitle;

/**
 * The title of the alternative button. The alternative button represents a second option for
 * the user.
 *
 * If you set this property to `nil`, no alternative button will be added (this is the default).
 */

@property (nonatomic, strong, nullable) NSString *alternativeButtonTitle;

#pragma mark - BLTNItem

/**
 * The object managing the item.
 *
 * This property is set when the item is currently being displayed. It will be set to `nil` when
 * the item is removed from bulletin.
 */

@property (nonatomic, nullable, weak) BLTNItemManager *manager;

/**
 * Whether the page can be dismissed.
 *
 * If you set this value to `true`, the user will be able to dismiss the bulletin by tapping outside
 * of the card or by swiping down.
 *
 * You should set it to `true` for the last item you want to display.
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
 * Whether the page should start with an activity indicator.
 *
 * Set this value to `false` to display the elements right away. If you set it to `true`,
 * you'll need to call `manager?.hideActivityIndicator()` to show the UI.
 *
 * This defaults to `false`.
 */

@property (nonatomic) BOOL shouldStartWithActivityIndicator;

/**
 * Whether the item should move with the keyboard.
 *
 * You must set it to `true` if the item displays a text field. Otherwise, you can set it to `false` if you
 * don't want the bulletin to move when system alerts are displayed.
 *
 * This value defaults to `true`.
 */

@property (nonatomic) BOOL shouldRespondToKeyboardChanges;

/**
 * The item to display after this one.
 *
 * If you set this value, you'll be able to call `displayNextItem()` to push the next item to
 * the stack.
 */

@property (nonatomic, strong, nullable) id<BLTNItem> nextItem;

/**
 * The block of code to execute when the bulletin item is presented. This is called after the
 * bulletin is moved onto the view.
 *
 * - parameter item: The item that is being presented.
 */

@property (nonatomic, nullable) void(^presentationHandler)(id<BLTNItem> _Nonnull);

/**
 * The block of code to execute when the bulletin item is dismissed. This is called when the bulletin
 * is moved out of view.
 *
 * You can leave it `nil` if `isDismissable` is set to false.
 */

@property (nonatomic, nullable) void(^dismissalHandler)(id<BLTNItem> _Nonnull);

#pragma mark - Customization

/**
 * The appearance manager used to generate the interface of the page.
 *
 * Use this property to customize the appearance of the generated elements.
 *
 * Make sure to customize the appearance before presenting the page. Changing the appearance properties
 * after the bulletin page was presented has no effect.
 */

@property (nonatomic, strong, nonnull) BLTNItemAppearance *appearance;

/**
 * The type of interface builder to use to generate the components.
 *
 * Make sure to customize this property before presenting the page. Changing the interface builder type
 * after the bulletin page was presented has no effect.
 */

@property (nonatomic, strong, nonnull) Class interfaceBuilderType;

#pragma mark - Buttons

/**
 * The action button managed by the item.
 */

@property (nonatomic, strong, nullable, readonly) UIButton *actionButton;

/**
 * The alternative button managed by the item.
 */

@property (nonatomic, strong, nullable, readonly) UIButton *alternativeButton;

/**
 * The code to execute when the action button is tapped.
 */

@property (nonatomic, nullable) void(^actionHandler)(BLTNActionItem * _Nonnull);

/**
 * The code to execute when the alternative button is tapped.
 */

@property (nonatomic, nullable) void(^alternativeHandler)(BLTNActionItem * _Nonnull);

/**
 * Handles a tap on the action button.
 *
 * You can override this method to add custom tap handling. You have to call `super.actionButtonTapped(sender:)`
 * in your implementation.
 */

- (void)actionButtonTappedWithSender:(UIButton * _Nonnull)sender NS_SWIFT_NAME(actionButtonTapped(sender:));

/**
 * Handles a tap on the alternative button.
 *
 * You can override this method to add custom tap handling. You have to call `super.alternativeButtonTapped(sender:)`
 * in your implementation.
 */

- (void)alternativeButtonTappedWithSender:(UIButton * _Nonnull)sender NS_SWIFT_NAME(alternativeButtonTapped(sender:));

#pragma mark - View Management

/**
 * The views to display below the buttons.
 *
 * You can override this method to insert custom views after the buttons. The default implementation returns `nil` and
 * does not append footer elements.
 *
 * This method is called inside `makeArrangedSubviews` after the buttons are created.
 *
 * - parameter interfaceBuilder: The interface builder used to create the buttons.
 * - returns: The footer views for the item, or `nil` if no footer views should be added.
 */

- (NSArray<UIView *> * _Nullable)makeFooterViewsWithInterfaceBuilder:(BLTNInterfaceBuilder * _Nonnull)interfaceBuilder;

/**
 * Creates the content views of the page. Content views are displayed above the buttons.
 *
 * You must override this method to return the elements displayed above the buttons. Your implementation
 * must not call `super`.
 *
 * If you do not implement this method, an exception will be raised.
 *
 * - parameter interfaceBuilder: The interface builder used to create the buttons.
 * - returns: The views to display above the buttons.
 */

- (NSArray<UIView*> * _Nonnull)makeContentViewsWithInterfaceBuilder:(BLTNInterfaceBuilder * _Nonnull)interfaceBuilder;

/**
 * Creates the list of views to display on the bulletin.
 *
 * This is an implementation detail of `BLTNItem` and you should not call it directly. Subclasses should not override this method, and should
 * implement `makeContentViewsWithInterfaceBuilder:` instead.
 */

- (NSArray<UIView*> * _Nonnull)makeArrangedSubviews;

#pragma mark - Events

/**
 * Called by the manager when the item was added to the bulletin.
 *
 * Override this function to configure your managed views, and allocate any resources required
 * for this item. Make sure to call `super` if you override this method.
 */

- (void)setUp;

/**
 * Called by the manager when the item was removed from the bulletin view.
 *
 * Override this method if elements you returned in `makeContentViews` need cleanup. Make sure
 * to call `super` if you override this method.
 *
 * This is an implementation detail of `BLTNItem` and you should not call it directly.
 */

- (void)tearDown;
    
/**
* Called by the manager when bulletin item is about to be pushed onto the view.
*/
    
- (void)willDisplay;

/**
 * Called by the manager when bulletin item is pushed onto the view.
 *
 * By default, this method calls trhe `presentationHandler` of the action item. Override this
 * method if you need to perform additional preparation after presentation (although using
 * `setUp` is preferred).
 */

- (void)onDisplay;

/**
 * Called by the manager when bulletin item is dismissed. This is called after the bulletin
 * is moved out of view.
 *
 * By default, this method calls trhe `dismissalHandler` of the action item. Override this
 * method if you need to perform additional cleanup after dismissal (although using
 * `tearDown` is preferred).
 */

- (void)onDismiss;

@end
