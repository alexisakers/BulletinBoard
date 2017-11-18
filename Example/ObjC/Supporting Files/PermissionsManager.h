/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import CoreLocation;

@interface PermissionsManager : NSObject

/**
 * Requests permission for system features.
 */

+(PermissionsManager*)sharedManager;

/// Show the notification permission prompt.
-(void)requestLocalNotifications;

/// Show the location permission prompt.
-(void)requestWhenInUseLocation;

@end
