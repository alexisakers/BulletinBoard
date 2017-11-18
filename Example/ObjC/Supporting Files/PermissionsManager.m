/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "PermissionsManager.h"

@implementation PermissionsManager {
    CLLocationManager* _locationManager;
}

+(PermissionsManager*)sharedManager {

    static PermissionsManager *manager;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        manager = [[PermissionsManager alloc] init];
    });

    return manager;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

-(void)requestLocalNotifications {

    UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:NULL];

    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

};

-(void)requestWhenInUseLocation {
    [_locationManager requestWhenInUseAuthorization];
}

@end
