/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import BulletinBoard;

/**
 * A set of tools to interact with the demo data.
 *
 * This demonstrates how to create and configure bulletin items.
 */

@interface BulletinDataSource : NSObject

#pragma mark Pages

/**
 * Create the introduction page.
 *
 * This creates a `FeedbackPageBulletinItem` with: a title, an image, a description text and
 * and action button.
 *
 * The action button presents the next item (the textfield page).
 */

+(PageBulletinItem *)makeIntroPage;

/**
 * Create the location page.
 *
 * This creates a `PageBulletinItem` with: a title, an image, a description text, and an action
 * button. The item can be dismissed. The tint color of the action button is customized.
 *
 * The action button dismisses the bulletin. The alternative button pops to the root item.
 */

+(PageBulletinItem *)makeCompletionPage;

#pragma mark User Defaults

/// The current favorite tab index.
+(NSInteger)favoriteTabIndex;

/// The current favorite tab index.
+(void)setFavoriteTabIndex:(NSInteger)newValue;

/// Whether user completed setup.
+(BOOL)userDidCompleteSetup;

/// Whether user completed setup.
+(void)setUserDidCompleteSetup:(BOOL)newValue;

@end

#pragma mark Notifications

/**
 * The setup did complete.
 *
 * The user info dictionary is empty.
 */

extern NSString *const SetupDidCompleteNotificationName;

/**
 * The favorite tab index did change.
 *
 * The user info dictionary contains the following values:
 *
 * - `"Index"` = an integer with the new favorite tab index.
 */

extern NSString *const FavoriteTabIndexDidChangeNotificationName;
