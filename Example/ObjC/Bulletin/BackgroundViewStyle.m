/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "BackgroundViewStyle.h"

@implementation BackgroundViewStyle {
    NSString *_name;
    BulletinBackgroundViewStyle *_style;
}

-(instancetype)initWithName:(NSString *)name style:(BulletinBackgroundViewStyle *)style {
    self = [super init];
    if (self) {
        _name = name;
        _style = style;
    }
    return self;
};

+(NSArray<BackgroundViewStyle*> *)allStyles {

    NSMutableArray<BackgroundViewStyle*> *styles = [NSMutableArray array];

    BackgroundViewStyle *none = [[BackgroundViewStyle alloc] initWithName:@"None"
                                                                    style:[BulletinBackgroundViewStyle none]];

    BackgroundViewStyle *dimmed = [[BackgroundViewStyle alloc] initWithName:@"Dimmed"
                                                                      style:[BulletinBackgroundViewStyle dimmed]];

    [styles addObject:none];
    [styles addObject:dimmed];

    if (@available(iOS 10.0, *)) {

        BackgroundViewStyle *extraLight = [[BackgroundViewStyle alloc] initWithName:@"Light"
                                                                              style:[BulletinBackgroundViewStyle blurredLight]];

        BackgroundViewStyle *light = [[BackgroundViewStyle alloc] initWithName:@"Extra Light"
                                                                         style:[BulletinBackgroundViewStyle blurredExtraLight]];

        BackgroundViewStyle *dark = [[BackgroundViewStyle alloc] initWithName:@"Dark"
                                                                         style:[BulletinBackgroundViewStyle blurredDark]];

        BackgroundViewStyle *extraDark = [[BackgroundViewStyle alloc] initWithName:@"Extra Dark"
                                                                             style:[BulletinBackgroundViewStyle blurredWithStyle:3 isDark:YES]];

        [styles addObject:extraLight];
        [styles addObject:light];
        [styles addObject:dark];
        [styles addObject:extraDark];

    }

    return (NSArray<BackgroundViewStyle*> *)styles;

};

+(BackgroundViewStyle *)defaultStyle {

    return [[BackgroundViewStyle alloc] initWithName:@"Dimmed"
                                               style:[BulletinBackgroundViewStyle dimmed]];

};

@end
