/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import BulletinBoard;

/**
 * A background view style.
 */

@interface BackgroundViewStyle : NSObject

/// The name of the style.
@property NSString *name;

/// The raw style to use.
@property BulletinBackgroundViewStyle *style;

/// All the styles.
+(NSArray<BackgroundViewStyle*> *)allStyles;

/// The default style.
+(BackgroundViewStyle *)defaultStyle;

@end
