/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import BLTNBoard;

/**
 * A background view style.
 */

@interface BackgroundViewStyle : NSObject

/// The name of the style.
@property (nonatomic, copy) NSString *name;

/// The raw style to use.
@property (nonatomic) BLTNBackgroundViewStyle *style;

/// All the styles.
@property (class, copy, readonly) NSArray<BackgroundViewStyle*> *allStyles;

/// The default style.
@property (class, readonly) BackgroundViewStyle *defaultStyle;

@end
