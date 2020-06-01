/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;

#import "BLTNActionItem.h"

@class BLTNTitleLabelContainer;

NS_ASSUME_NONNULL_BEGIN

/**
 * A standard bulletin item with a title and optional additional informations. It can display a large
 * action button and a smaller button for alternative options.
 *
 * - If you need to display custom elements with the standard buttons, subclass `BLTNPageItem` and
 * implement the `makeArrangedSubviews` method to return the elements to display above the buttons.
 *
 * You can also override this class to customize button tap handling. Override the `actionButtonTapped(sender:)`
 * and `alternativeButtonTapped(sender:)` methods to handle tap events. Make sure to call `super` in your
 * implementations if you do.
 *
 * Use the `appearance` property to customize the appearance of the page. If you want to use a different interface
 * builder type, change the `interfaceBuilderType` property.
 */

@interface BLTNPageItem : BLTNActionItem

/**
 * Creates a bulletin page with the specified title.
 * - parameter title: The title of the page.
 */

- (instancetype)initWithTitle:(NSString *)title;

#pragma mark - Page Contents

/// The title of the page.
@property (nonatomic, nonnull, readonly) NSString *title;

/**
 * An image to display below the title.
 *
 * If you set this property to `nil`, no image will be displayed (this is the default).
 *
 * The image should have a size of 128x128 pixels (@1x).
 */

@property (nonatomic, nullable) UIImage *image;

/// An accessibility label which gets announced to VoiceOver users if the image gets focused.
@property (nonatomic, nullable) NSString *imageAccessibilityLabel;

/**
 * An description text to display below the image.
 *
 * If you set this property to `nil`, no label will be displayed (this is the default).
 */

@property (nonatomic, nullable) NSString *descriptionText;

/**
 * An attributed description text to display below the image.
 *
 * If you set this property to `nil`, no label will be displayed (this is the default). The attributed
 * text takes priority over the regular description label. If you set both values, only the
 * `attributedDescriptionText` will be used.
 */

@property (nonatomic, nullable) NSAttributedString *attributedDescriptionText;

#pragma mark - View Management

@property (nonatomic, nonnull, readonly) BLTNTitleLabelContainer *titleLabel;
@property (nonatomic, nullable, readonly) UILabel *descriptionLabel;
@property (nonatomic, nullable, readonly) UIImageView *imageView;

#pragma mark - Customization

/**
 * The views to display above the title.
 *
 * You can override this method to insert custom views before the title. The default implementation returns `nil` and
 * does not append header elements.
 *
 * This method is called inside `makeArrangedSubviews` before the title is created.
 *
 * - parameter interfaceBuilder: The interface builder used to create the title.
 * - returns: The header views for the item, or `nil` if no header views should be added.
 */

- (NSArray<UIView *> * _Nullable)makeHeaderViewsWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder;

/**
 * The views to display below the title.
 *
 * You can override this method to insert custom views after the title. The default implementation returns `nil` and
 * does not append elements after the title.
 *
 * This method is called inside `makeArrangedSubviews` after the title is created.
 *
 * - parameter interfaceBuilder: The interface builder used to create the title.
 * - returns: The views to display after the title, or `nil` if no views should be added.
 */

- (NSArray<UIView *> * _Nullable)makeViewsUnderTitleWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder;

/**
 * The views to display below the image.
 *
 * You can override this method to insert custom views after the image. The default implementation returns `nil` and
 * does not append elements after the image.
 *
 * This method is called inside `makeArrangedSubviews` after the image is created.
 *
 * - parameter interfaceBuilder: The interface builder used to create the image.
 * - returns: The views to display after the image, or `nil` if no views should be added.
 */

- (NSArray<UIView *> * _Nullable)makeViewsUnderImageWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder;

/**
 * The views to display below the description.
 *
 * You can override this method to insert custom views after the description. The default implementation
 * returns `nil` and does not append elements after the description.
 *
 * This method is called inside `makeArrangedSubviews` after the description is created.
 *
 * - parameter interfaceBuilder: The interface builder used to create the description.
 * - returns: The views to display after the description, or `nil` if no views should be added.
 */

- (NSArray<UIView *> * _Nullable)makeViewsUnderDescriptionWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder;

@end

NS_ASSUME_NONNULL_END
