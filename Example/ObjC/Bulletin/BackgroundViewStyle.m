/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "BackgroundViewStyle.h"

@implementation BackgroundViewStyle

-(instancetype)initWithName:(NSString *)name style:(BLTNBackgroundViewStyle *)style {
    self = [super init];
    if (self) {
        self.name = name;
        self.style = style;
    }
    return self;
};

+ (NSArray<BackgroundViewStyle*> *)allStyles
{
    NSMutableArray<BackgroundViewStyle*> *styles = [NSMutableArray array];

    BackgroundViewStyle *none = [[BackgroundViewStyle alloc] initWithName:@"None"
                                                                    style:[BLTNBackgroundViewStyle none]];

    BackgroundViewStyle *dimmed = [[BackgroundViewStyle alloc] initWithName:@"Dimmed"
                                                                      style:[BLTNBackgroundViewStyle dimmed]];

    [styles addObject:none];
    [styles addObject:dimmed];

    if (@available(iOS 10.0, *)) {

        BackgroundViewStyle *extraLight = [[BackgroundViewStyle alloc] initWithName:@"Light"
                                                                              style:[BLTNBackgroundViewStyle blurredLight]];

        BackgroundViewStyle *light = [[BackgroundViewStyle alloc] initWithName:@"Extra Light"
                                                                         style:[BLTNBackgroundViewStyle blurredExtraLight]];

        BackgroundViewStyle *dark = [[BackgroundViewStyle alloc] initWithName:@"Dark"
                                                                         style:[BLTNBackgroundViewStyle blurredDark]];

        BackgroundViewStyle *extraDark = [[BackgroundViewStyle alloc] initWithName:@"Extra Dark"
                                                                             style:[BLTNBackgroundViewStyle blurredWithStyle:3 isDark:YES]];

        [styles addObject:extraLight];
        [styles addObject:light];
        [styles addObject:dark];
        [styles addObject:extraDark];
    }

    return (NSArray<BackgroundViewStyle*> *)styles;
}

+ (BackgroundViewStyle *)defaultStyle
{
    return [[BackgroundViewStyle alloc] initWithName:@"Dimmed"
                                               style:[BLTNBackgroundViewStyle dimmed]];
}

@end
