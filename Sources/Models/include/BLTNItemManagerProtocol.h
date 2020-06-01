/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@protocol BLTNItem;

NS_ASSUME_NONNULL_BEGIN

/**
 * A protocol for objects that enable your items to interact with the presented bulletin.
 */

@protocol BLTNItemManagerProtocol <NSObject>

/**
 * Whether swipe to dismiss should be allowed. Defaults to true.
 *
 * If you set this value to true, the user will be able to drag the card, and swipe down to
 * dismiss it (if allowed by the current item).
 *
 * If you set this value to false, no pan gesture will be recognized, and swipe to dismiss
 * won't be available.
 */

@property (nonatomic, readonly) BOOL allowsSwipeInteraction;

/**
 * Tells us if a bulletin is currently being shown. Defaults to false.
*/

@property (nonatomic, readonly) BOOL isShowingBulletin;

/**
 * Hides the contents of the stack and displays an activity indicator view.
 *
 * Use this method if you need to perform a long task or fetch some data before changing the item.
 *
 * Displaying the loading indicator does not change the height of the page or the current item. It will disable
 * dismissal by tapping and swiping to allow the task to complete and avoid resource deallocation.
 *
 * @param color The color of the activity indicator to display. Defaults to .label on iOS 13 and .black on older systems.
 *
 * Displaying the loading indicator does not change the height of the page or the current item.
 */

- (void)displayActivityIndicatorWithColor:(nullable UIColor *)color NS_SWIFT_NAME(displayActivityIndicator(color:));

/**
 * Hides the activity indicator and displays the current item.
 *
 * You can also call one of `popItem`, `popToRootItem` and `pushItem` if you need to hide the activity
 * indicator and change the current item.
 */

- (void)hideActivityIndicator;

/**
 * Displays a new item after the current one.
 * @param item The item to display.
 */

- (void)pushItem:(id<BLTNItem>)item NS_SWIFT_NAME(push(item:));

/**
 * Removes the current item from the stack and displays the previous item.
 */

- (void)popItem;

/**
 * Removes items from the stack until a specific item is found.
 * @param item The item to seek.
 * @param dismiss If true, dismiss bullein if not found. Otherwise popToRootItem()
 */

- (void)popToItem:(id<BLTNItem>)item
        orDismiss:(BOOL)dismiss NS_SWIFT_NAME(popTo(item:orDismiss:));

/**
 * Removes all the items from the stack and displays the root item.
 */

- (void)popToRootItem;

/**
 * Displays the next item, if the `next` property of the current item is set.
 *
 * @warning If you call this method but `next` is `nil`, an exception will be raised.
 */

- (void)displayNextItem;

/**
 * Dismisses the bulletin and clears the current page. You will have to call `prepare` before
 * presenting the bulletin again.
 *
 * This method will call the `dismissalHandler` block of the current item if it was set.
 *
 * @param animated Whether to animate dismissal. Defaults to `true`.
 */

- (void)dismissBulletinAnimated:(BOOL)animated;

/**
 * Presents a view controller above the bulletin card.
 *
 * This is useful if you want to present an alert or a Safari view contoller in response to user
 * action.
 *
 * @param viewController The view controller to present.
 * @param animated Whether presentation should be animated.
 * @param completion An optional completion block to run after presentation has completed.
 */

- (void)presentViewControllerAboveBulletin:(UIViewController *)viewController
                                  animated:(BOOL)animated
                                completion:(void (^ __nullable)(void))completion NS_SWIFT_NAME(present(_:animated:completion:));

@end

NS_ASSUME_NONNULL_END
