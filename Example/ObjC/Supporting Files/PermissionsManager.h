/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import CoreLocation;

/**
 * Manages the permissions of the app.
 */

@interface PermissionsManager : NSObject

/**
 * Requests permission for system features.
 */

+ (PermissionsManager*)sharedManager;

/// Show the notification permission prompt.
- (void)requestLocalNotifications;

/// Show the location permission prompt.
- (void)requestWhenInUseLocation;

@end
