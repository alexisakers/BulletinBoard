/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "BulletinDataSource.h"
#import "PermissionsManager.h"
#import "TextFieldBulletinPage.h"
#import "PetSelectorBulletinPage.h"

@implementation BulletinDataSource

+(BLTNPageItem *)makeIntroPage {

    BLTNPageItem *page = [[BLTNPageItem alloc] initWithTitle:@"Welcome to PetBoard"];
    [page setImage:[UIImage imageNamed:@"RoundedIcon"]];
    [page setImageAccessibilityLabel:@"😻"];

    [page setDescriptionText:@"Discover curated images of the best pets in the world."];
    [page setActionButtonTitle:@"Configure"];

    [page setAppearance:[BulletinDataSource makeLightAppearance]];
    page.dismissable = YES;
    page.shouldStartWithActivityIndicator = YES;

    // After the item is presented, show the contents after 3 seconds
    [page setPresentationHandler:^(id<BLTNItem> _Nonnull _item) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_item.manager hideActivityIndicator];
        });

    }];

    [page setActionHandler:^(BLTNActionItem * _Nonnull _item) {
        [[_item manager] displayNextItem];
    }];

    [page setNextItem:[BulletinDataSource makeTextFieldPage]];

    return page;

};

+(TextFieldBulletinPage *)makeTextFieldPage {

    TextFieldBulletinPage *page = [[TextFieldBulletinPage alloc] initWithTitle:@"Enter Your Name"];
    page.descriptionText = @"To create your profile, please tell us your name. We will use it to customize your feed.";
    page.actionButtonTitle = @"Sign Up";

    [page setActionHandler:^(BLTNActionItem * _Nonnull _item) {
        [[_item manager] displayNextItem];
    }];

    [page setNextItem:[BulletinDataSource makeNotificationsPage]];

    return page;

};

+(BLTNPageItem *)makeNotificationsPage {

    BLTNPageItem* page = [[BLTNPageItem alloc] initWithTitle:@"Push Notifications"];
    [page setAppearance:[BulletinDataSource makeLightAppearance]];

    [page setDescriptionText:@"Receive push notifications when new photos of pets are available."];
    [page setActionButtonTitle:@"Subscribe"];
    [page setAlternativeButtonTitle:@"Not now"];
    [page setImage:[UIImage imageNamed:@"NotificationPrompt"]];

    page.dismissable = NO;

    [page setActionHandler:^(BLTNActionItem * _Nonnull _item) {
        [[PermissionsManager sharedManager] requestLocalNotifications];
        [[_item manager] displayNextItem];
    }];

    [page setAlternativeHandler:^(BLTNActionItem * _Nonnull _item) {
        [[_item manager] displayNextItem];
    }];

    [page setNextItem:[BulletinDataSource makeLocationPage]];

    return page;

};

+(BLTNPageItem *)makeLocationPage {

    BLTNPageItem* page = [[BLTNPageItem alloc] initWithTitle:@"Customize Feed"];
    [page setImage:[UIImage imageNamed:@"LocationPrompt"]];
    [page setImageAccessibilityLabel:@"Location Icon"];

    [page setDescriptionText:@"We can use your location to customize the feed. This data will be sent to our servers anonymously. You can update your choice later in the app settings."];
    [page setActionButtonTitle:@"Send location data"];
    [page setAlternativeButtonTitle:@"No thanks"];

    [[page appearance] setShouldUseCompactDescriptionText:YES];
    page.dismissable = NO;

    [page setActionHandler:^(BLTNActionItem * _Nonnull _item) {
        [[PermissionsManager sharedManager] requestWhenInUseLocation];
        [[_item manager] displayNextItem];
    }];

    [page setAlternativeHandler:^(BLTNActionItem * _Nonnull _item) {
        [[_item manager] displayNextItem];
    }];

    [page setNextItem:[BulletinDataSource makeChoicePage]];

    return page;

};

+ (PetSelectorBulletinPage *)makeChoicePage
{
    PetSelectorBulletinPage* page = [PetSelectorBulletinPage new];
    [page setActionButtonTitle:@"Select"];
    return page;
}

+(BLTNPageItem *)makeCompletionPage {

    UIColor *greenColor = [UIColor colorWithRed:0.2980392157
                                          green:0.8509803922
                                           blue:0.3921568627
                                          alpha:1];

    BLTNPageItem* page = [[BLTNPageItem alloc] initWithTitle:@"Setup Completed"];

    [page setImage:[UIImage imageNamed:@"IntroCompletion"]];
    [page setImageAccessibilityLabel:@"Checkmark"];

    [[page appearance] setActionButtonColor:greenColor];
    [[page appearance] setImageViewTintColor:greenColor];
    [[page appearance] setActionButtonTitleColor:[UIColor whiteColor]];

    [page setDescriptionText:@"PetBoard is ready for you to use. Happy browsing!."];
    [page setActionButtonTitle:@"Get started"];
    [page setAlternativeButtonTitle:@"Replay"];

    page.dismissable = NO;

    [page setDismissalHandler:^(id<BLTNItem> _Nonnull _item) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SetupDidCompleteNotificationName object:_item];
    }];

    [page setActionHandler:^(BLTNActionItem * _Nonnull _item) {
        [[_item manager] dismissBulletinAnimated:YES];
    }];

    [page setAlternativeHandler:^(BLTNActionItem * _Nonnull _item) {
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
};

+(void)setUserDidCompleteSetup:(BOOL)newValue {
    [[NSUserDefaults standardUserDefaults] setBool:newValue forKey:@"PetBoardUserDidCompleteSetup"];
};

+(BOOL)useAvenirFont {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"UseAvenirFont"];
};

+(void)setUseAvenirFont:(BOOL)newValue {
    [[NSUserDefaults standardUserDefaults] setBool:newValue forKey:@"UseAvenirFont"];
};

+(NSString *)currentFontName {
    return [self useAvenirFont] ? @"Avenir Next" : @"San Francisco";
}

#pragma mark Font

+(BLTNItemAppearance *)makeLightAppearance {

    BLTNItemAppearance *appearance = [[BLTNItemAppearance alloc] init];

    if ([BulletinDataSource useAvenirFont]) {

        [appearance setTitleFontDescriptor:[UIFontDescriptor fontDescriptorWithName:@"AvenitNext-Medium" matrix:CGAffineTransformIdentity]];

        [appearance setDescriptionFontDescriptor:[UIFontDescriptor fontDescriptorWithName:@"AvenirNext-Regular" matrix:CGAffineTransformIdentity]];

        [appearance setButtonFontDescriptor:[UIFontDescriptor fontDescriptorWithName:@"AvenirNext-DemiBold" matrix:CGAffineTransformIdentity]];

    }

    return appearance;

};

@end

#pragma mark Notifications

NSString *const FavoriteTabIndexDidChangeNotificationName = @"PetBoardFavoriteTabIndexDidChangeNotification";
NSString *const SetupDidCompleteNotificationName = @"PetBoardSetupDidCompleteNotification";
