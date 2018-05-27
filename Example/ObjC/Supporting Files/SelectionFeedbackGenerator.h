/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;

/**
 * A 3D Touch selection feedback generator wrapper that uses the API only when available.
 */

@interface SelectionFeedbackGenerator : NSObject

/**
 * Prepares the taptic engine.
 */

- (void)prepare;

/**
 * Plays a selection change haptic feedback.
 */

- (void)selectionChanged;

@end
