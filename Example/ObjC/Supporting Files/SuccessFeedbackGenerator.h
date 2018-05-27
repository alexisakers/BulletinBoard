/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;

/**
 * A 3D Touch success feedback generator wrapper that uses the API only when available.
 */

@interface SuccessFeedbackGenerator : NSObject

/**
 * Prepares the taptic engine.
 */

- (void)prepare;

/**
 * Plays a success haptic feedback.
 */

- (void)notifySuccess;

@end

