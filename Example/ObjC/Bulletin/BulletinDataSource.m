/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "BulletinDataSource.h"
#import "PermissionsManager.h"

@import CustomBulletins;

@implementation BulletinDataSource

+ (BLTNPageItem *)makeIntroPage
{
    BLTNPageItem *page = [[BLTNPageItem alloc] initWithTitle:@"Welcome to\nPetBoard"];
    page.appearance = [self makeLightAppearance];

    page.image = [UIImage imageNamed:@"RoundedIcon"];
    page.imageAccessibilityLabel = @"😻";

    page.descriptionText = @"Discover curated images of the best pets in the world.";
    page.actionButtonTitle = @"Configure";

    page.isDismissable = [self userDidCompleteSetup];
    page.shouldStartWithActivityIndicator = YES;

    // After the item is presented, show the contents after 3 seconds
    page.presentationHandler = ^(BLTNItem *_item) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_item.manager hideActivityIndicator];
        });

    };

    page.actionHandler = ^(BLTNActionItem * _Nonnull _item) {
        [[_item manager] displayNextItem];
    };

    page.nextItem = [self makeTextFieldPage];

    return page;

}

+ (TextFieldBulletinPage *)makeTextFieldPage
{
    TextFieldBulletinPage *page = [[TextFieldBulletinPage alloc] initWithTitle:@"Enter Your Name"];
    page.appearance = [self makeLightAppearance];

    page.descriptionText = @"To create your profile, please tell us your name. We will use it to customize your feed.";
    page.actionButtonTitle = @"Sign Up";

    page.isDismissable = NO;

    page.textInputHandler = ^(TextFieldBulletinPage * item, NSString * _Nullable text) {
        NSLog(@"Text: %@", text);
        [item.manager displayNextItem];
    };

    page.nextItem = [self makeNotificationsPage];
    return page;

}

+ (BLTNPageItem *)makeNotificationsPage
{
    BLTNPageItem* page = [[BLTNPageItem alloc] initWithTitle:@"Push Notifications"];
    page.appearance = [self makeLightAppearance];

    page.image = [UIImage imageNamed:@"NotificationPrompt"];
    page.imageAccessibilityLabel = @"Notifications Icon";

    page.descriptionText = @"Receive push notifications when new photos of pets are available.";
    page.actionButtonTitle = @"Subscribe";
    page.alternativeButtonTitle = @"Not now";

    page.isDismissable = NO;

    page.actionHandler = ^(BLTNActionItem * _Nonnull _item) {
        [[PermissionsManager sharedManager] requestLocalNotifications];
        [[_item manager] displayNextItem];
    };

    page.alternativeHandler = ^(BLTNActionItem * _Nonnull _item) {
        [[_item manager] displayNextItem];
    };

    page.nextItem = [self makeLocationPage];

    return page;

}

+ (BLTNPageItem *)makeLocationPage
{
    BLTNPageItem* page = [[BLTNPageItem alloc] initWithTitle:@"Customize Feed"];
    page.appearance = [self makeLightAppearance];

    page.image = [UIImage imageNamed:@"LocationPrompt"];
    page.imageAccessibilityLabel = @"Location Icon";

    page.descriptionText = @"We can use your location to customize the feed. This data will be sent to our servers anonymously. You can update your choice later in the app settings.";
    page.actionButtonTitle = @"Send location data";
    page.alternativeButtonTitle = @"No thanks";

    page.isDismissable = NO;

    page.actionHandler = ^(BLTNActionItem * _Nonnull _item) {
        [[PermissionsManager sharedManager] requestWhenInUseLocation];
        [[_item manager] displayNextItem];
    };

    page.alternativeHandler = ^(BLTNActionItem * _Nonnull _item) {
        [[_item manager] displayNextItem];
    };

    page.nextItem = [self makeChoicePage];

    return page;
}

+ (PetSelectorBulletinPage *)makeChoicePage
{
    PetSelectorBulletinPage* page = [[PetSelectorBulletinPage alloc] initWithCompletionHandler:^void (BLTNItem * currentItem) {
        BLTNPageItem *completionPage = [BulletinDataSource makeCompletionPage];
        [currentItem.manager pushItem:completionPage];
    }];
    
    page.actionButtonTitle = @"Select";
    page.descriptionText = @"Your favorite pets will appear when you open the app.";
    
    page.appearance = [self makeLightAppearance];
    page.isDismissable = NO;

    return page;
}

+ (BLTNPageItem *)makeCompletionPage
{
    UIColor *greenColor = [UIColor colorWithRed:0.2980392157
                                          green:0.8509803922
                                           blue:0.3921568627
                                          alpha:1];

    BLTNPageItem* page = [[BLTNPageItem alloc] initWithTitle:@"Setup Completed"];
    page.appearance = [self makeLightAppearance];

    page.appearance.actionButtonColor = greenColor;
    page.appearance.imageViewTintColor = greenColor;
    page.appearance.actionButtonTitleColor = [UIColor whiteColor];

    page.image = [UIImage imageNamed:@"IntroCompletion"];
    page.imageAccessibilityLabel = @"Checkmark";

    page.descriptionText = @"PetBoard is ready for you to use. Happy browsing!.";
    page.actionButtonTitle = @"Get started";
    page.alternativeButtonTitle = @"Replay";

    page.isDismissable = NO;

    page.actionHandler = ^(BLTNActionItem * _Nonnull _item) {
        [[_item manager] dismissBulletinAnimated:YES];
    };

    page.alternativeHandler = ^(BLTNActionItem * _Nonnull _item) {
        [[_item manager] popToRootItem];
    };

    page.dismissalHandler = ^(BLTNItem *_item) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SetupDidCompleteNotificationName object:_item];
    };

    page.nextItem = [self makeChoicePage];

    return page;
}

#pragma mark - User Defaults

+ (NSInteger)favoriteTabIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey: @"PetBoardFavoriteTabIndex"];
}

+ (void)setFavoriteTabIndex:(NSInteger)newValue {
    [[NSUserDefaults standardUserDefaults] setInteger:newValue forKey:@"PetBoardFavoriteTabIndex"];
}

+ (BOOL)userDidCompleteSetup {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"PetBoardUserDidCompleteSetup"];
}

+ (void)setUserDidCompleteSetup:(BOOL)newValue {
    [[NSUserDefaults standardUserDefaults] setBool:newValue forKey:@"PetBoardUserDidCompleteSetup"];
}

+ (BOOL)useAvenirFont {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"UseAvenirFont"];
}

+ (void)setUseAvenirFont:(BOOL)newValue {
    [[NSUserDefaults standardUserDefaults] setBool:newValue forKey:@"UseAvenirFont"];
}

+ (NSString *)currentFontName {
    return self.useAvenirFont ? @"Avenir Next" : @"San Francisco";
}

#pragma mark Font

+ (BLTNItemAppearance *)makeLightAppearance
{
    BLTNItemAppearance *appearance = [[BLTNItemAppearance alloc] init];

    if (self.useAvenirFont) {

        appearance.titleFontDescriptor = [UIFontDescriptor fontDescriptorWithName:@"AvenitNext-Medium"
                                                                           matrix:CGAffineTransformIdentity];

        appearance.descriptionFontDescriptor = [UIFontDescriptor fontDescriptorWithName:@"AvenirNext-Regular"
                                                                                 matrix:CGAffineTransformIdentity];

        appearance.buttonFontDescriptor = [UIFontDescriptor fontDescriptorWithName:@"AvenirNext-DemiBold"
                                                                            matrix:CGAffineTransformIdentity];

    }

    return appearance;
}

@end

#pragma mark Notifications

NSString *const FavoriteTabIndexDidChangeNotificationName = @"PetBoardFavoriteTabIndexDidChangeNotification";
NSString *const SetupDidCompleteNotificationName = @"PetBoardSetupDidCompleteNotification";
