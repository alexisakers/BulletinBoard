/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "PermissionsManager.h"

@interface PermissionsManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation PermissionsManager

+ (PermissionsManager*)sharedManager
{
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
        self.locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

-(void)requestLocalNotifications
{
    UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:NULL];

    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

-(void)requestWhenInUseLocation
{
    [self.locationManager requestWhenInUseAuthorization];
}

@end
