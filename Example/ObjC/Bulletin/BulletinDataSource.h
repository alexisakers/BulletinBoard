/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import BLTNBoard;

/**
 * A set of tools to interact with the demo data.
 *
 * This demonstrates how to create and configure bulletin items.
 */

@interface BulletinDataSource : NSObject

/// The current favorite tab index.
@property (class) NSInteger favoriteTabIndex;

/// Whether user completed setup.
@property (class) BOOL userDidCompleteSetup;

/// Whether to use the Avenir font.
@property (class) BOOL useAvenirFont;

/// The name of the current font.
@property (class, copy, readonly) NSString *currentFontName;

#pragma mark Pages

/**
 * Create the introduction page.
 *
 * This creates a `FeedbackPageBLTNItem` with: a title, an image, a description text and
 * and action button.
 *
 * The action button presents the next item (the textfield page).
 */

+(BLTNPageItem *)makeIntroPage;

/**
 * Create the location page.
 *
 * This creates a `PageBLTNItem` with: a title, an image, a description text, and an action
 * button. The item can be dismissed. The tint color of the action button is customized.
 *
 * The action button dismisses the bulletin. The alternative button pops to the root item.
 */

+(BLTNPageItem *)makeCompletionPage;

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
