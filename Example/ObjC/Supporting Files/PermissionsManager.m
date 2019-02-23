/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "PermissionsManager.h"

@import UserNotifications;

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
    UNAuthorizationOptions options = UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        // no-op
    }];
}

-(void)requestWhenInUseLocation
{
    [self.locationManager requestWhenInUseAuthorization];
}

@end
