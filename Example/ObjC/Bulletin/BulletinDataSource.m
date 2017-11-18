/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "BulletinDataSource.h"
#import "PermissionsManager.h"
#import "TextFieldBulletinPage.h"
#import "BBObjC-Swift.h"

@implementation BulletinDataSource

+(PageBulletinItem *)makeIntroPage {

    PageBulletinItem *page = [[PageBulletinItem alloc] initWithTitle:@"Welcome to PetBoard"];
    [page setImage:[UIImage imageNamed:@"RoundedIcon"]];
    [page setImageAccessibilityLabel:@"😻"];

    [page setDescriptionText:@"Discover curated images of the best pets in the world."];
    [page setActionButtonTitle:@"Configure"];

    [page setIsDismissable:NO];

    [page setActionHandler:^(PageBulletinItem * _Nonnull _item) {
        [[_item manager] displayNextItem];
    }];

    [page setNextItem:[BulletinDataSource makeTextFieldPage]];

    return page;

};

+(TextFieldBulletinPage *)makeTextFieldPage {

    TextFieldBulletinPage *page = [TextFieldBulletinPage new];

    [page setActionHandler:^(TextFieldBulletinPage * _Nonnull _item) {
        [[_item manager] displayNextItem];
    }];

    [page setNextItem:[BulletinDataSource makeNotificationsPage]];

    return page;

};

+(PageBulletinItem *)makeNotificationsPage {

    PageBulletinItem* page = [[PageBulletinItem alloc] initWithTitle:@"Push Notifications"];
    [page setImage:[UIImage imageNamed:@"NotificationPrompt"]];
    [page setImageAccessibilityLabel:@"Notifications Icon"];

    [page setDescriptionText:@"Receive push notifications when new photos of pets are available."];
    [page setActionButtonTitle:@"Subscribe"];
    [page setAlternativeButtonTitle:@"Not now"];

    [page setIsDismissable:NO];

    [page setActionHandler:^(PageBulletinItem * _Nonnull _item) {
        [[PermissionsManager sharedManager] requestLocalNotifications];
        [[_item manager] displayNextItem];
    }];

    [page setAlternativeHandler:^(PageBulletinItem * _Nonnull _item) {
        [[_item manager] displayNextItem];
    }];

    [page setNextItem:[BulletinDataSource makeLocationPage]];

    return page;

};

+(PageBulletinItem *)makeLocationPage {

    PageBulletinItem* page = [[PageBulletinItem alloc] initWithTitle:@"Customize Feed"];
    [page setImage:[UIImage imageNamed:@"LocationPrompt"]];
    [page setImageAccessibilityLabel:@"Location Icon"];

    [page setDescriptionText:@"We can use your location to customize the feed. This data will be sent to our servers anonymously. You can update your choice later in the app settings."];
    [page setActionButtonTitle:@"Send location data"];
    [page setAlternativeButtonTitle:@"No thanks"];

    [[page appearance] setShouldUseCompactDescriptionText:YES];
    [page setIsDismissable:NO];

    [page setActionHandler:^(PageBulletinItem * _Nonnull _item) {
        [[PermissionsManager sharedManager] requestWhenInUseLocation];
        [[_item manager] displayNextItem];
    }];

    [page setAlternativeHandler:^(PageBulletinItem * _Nonnull _item) {
        [[_item manager] displayNextItem];
    }];

    [page setNextItem:[BulletinDataSource makeChoicePage]];

    return page;

};

+(PetSelectorBulletinPage *)makeChoicePage {
    return [PetSelectorBulletinPage new];
};

+(PageBulletinItem *)makeCompletionPage {

    UIColor *greenColor = [UIColor colorWithRed:0.2980392157
                                          green:0.8509803922
                                           blue:0.3921568627
                                          alpha:1];

    PageBulletinItem* page = [[PageBulletinItem alloc] initWithTitle:@"Setup Completed"];

    [page setImage:[UIImage imageNamed:@"IntroCompletion"]];
    [page setImageAccessibilityLabel:@"Checkmark"];

    [[page appearance] setActionButtonColor:greenColor];
    [[page appearance] setImageViewTintColor:greenColor];
    [[page appearance] setActionButtonTitleColor:[UIColor whiteColor]];

    [page setDescriptionText:@"PetBoard is ready for you to use. Happy browsing!."];
    [page setActionButtonTitle:@"Get started"];
    [page setAlternativeButtonTitle:@"Replay"];

    [page setIsDismissable:YES];

    [page setDismissalHandler:^(id<BulletinItem> _Nonnull _item) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SetupDidCompleteNotificationName object:_item];
    }];

    [page setActionHandler:^(PageBulletinItem * _Nonnull _item) {
        [[_item manager] dismissBulletinAnimated:YES];
    }];

    [page setAlternativeHandler:^(PageBulletinItem * _Nonnull _item) {
        [[_item manager] popToRootItem];
    }];

    [page setNextItem:[BulletinDataSource makeChoicePage]];

    return page;

};

+(NSInteger)favoriteTabIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey: @"PetBoardFavoriteTabIndex"];
};

+(void)setFavoriteTabIndex:(NSInteger)newValue {
    [[NSUserDefaults standardUserDefaults] setInteger:newValue forKey:@"PetBoardFavoriteTabIndex"];
};

+(BOOL)userDidCompleteSetup {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"PetBoardUserDidCompleteSetup"];
}

+(void)setUserDidCompleteSetup:(BOOL)newValue {
    return [[NSUserDefaults standardUserDefaults] setBool:newValue forKey:@"PetBoardUserDidCompleteSetup"];
}

@end

#pragma mark Notifications

NSString *const FavoriteTabIndexDidChangeNotificationName = @"PetBoardFavoriteTabIndexDidChangeNotification";
NSString *const SetupDidCompleteNotificationName = @"PetBoardSetupDidCompleteNotification";
