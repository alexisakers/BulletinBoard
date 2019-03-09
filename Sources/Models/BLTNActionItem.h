/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;

#import "BLTNItem.h"

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
 * builder type, change the `interfaceBuilderType` property.
 */

@interface BLTNActionItem : BLTNItem

#pragma mark - Page Contents

/**
 * The title of the action button. The action button represents the main action for the item.
 *
 * If you set this property to `nil`, no action button will be added (this is the default).
 */

@property (nonatomic, strong, nullable) NSString *actionTitle;

/**
 * The title of the alternative button. The alternative button represents a second option for
 * the user.
 *
 * If you set this property to `nil`, no alternative button will be added (this is the default).
 */

@property (nonatomic, strong, nullable) NSString *alternateActionTitle;

#pragma mark - BLTNItem

/**
 * The block of code to execute when the bulletin item is about to be presented. This is called before the
 * bulletin is moved onto the view.
 *
 * - parameter item: The item that is being presented.
 */

@property (nonatomic, nullable) void(^willPresentHandler)(BLTNItem * _Nonnull);

/**
 * The block of code to execute when the bulletin item is presented. This is called after the
 * bulletin is moved onto the view.
 *
 * - parameter item: The item that is being presented.
 */

@property (nonatomic, nullable) void(^didPresentHandler)(BLTNItem * _Nonnull);

/**
 * The block of code to execute when the bulletin item is dismissed. This is called when the bulletin
 * is moved out of view.
 *
 * You can leave it `nil` if `isDismissable` is set to false.
 */

@property (nonatomic, nullable) void(^willDismissHandler)(BLTNItem * _Nonnull);

/**
 * The block of code to execute when the bulletin item is dismissed. This is called when the bulletin
 * is moved out of view.
 *
 * You can leave it `nil` if `isDismissable` is set to false.
 */

@property (nonatomic, nullable) void(^didDismissHandler)(BLTNItem * _Nonnull);

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
 * The button for the main action managed by the item.
 * @note You can configure this button before displaying
 */

@property (nonatomic, strong, nullable, readonly) UIButton *actionButton;

/**
 * The button for the alternate action managed by the item.
 */

@property (nonatomic, strong, nullable, readonly) UIButton *alternateActionButton;

/**
 * The code to execute when the action button is tapped.
 */

@property (nonatomic, nullable) void(^actionHandler)(BLTNActionItem * _Nonnull);

/**
 * The code to execute when the alternate button is tapped.
 */

@property (nonatomic, nullable) void(^alternateActionHandler)(BLTNActionItem * _Nonnull);

/**
 * Handles a tap on the action button.
 *
 * You can override this method to add custom tap handling. You have to call `super.actionButtonTapped(sender:)`
 * in your implementation.
 */

- (void)actionButtonTappedWithSender:(UIButton * _Nonnull)sender NS_SWIFT_NAME(actionButtonTapped(sender:)) NS_REQUIRES_SUPER;

/**
 * Handles a tap on the alternate action button.
 *
 * You can override this method to add custom tap handling. You have to call `super.alternativeButtonTapped(sender:)`
 * in your implementation.
 */

- (void)alternateActionButtonTappedWithSender:(UIButton * _Nonnull)sender NS_SWIFT_NAME(alternateActionButtonTapped(sender:)) NS_REQUIRES_SUPER;

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

@end
