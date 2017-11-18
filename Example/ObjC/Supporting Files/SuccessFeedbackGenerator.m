/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "SuccessFeedbackGenerator.h"

@implementation SuccessFeedbackGenerator {
    NSObject *_feedbackGenerator;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        if (@available(iOS 10.0, *)) {
            _feedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
        }

    }
    return self;
}

-(void)prepare {

    if (@available(iOS 10.0, *)) {
        [((UINotificationFeedbackGenerator *)_feedbackGenerator) prepare];
    }

};

-(void)notifySuccess {

    if (@available(iOS 10.0, *)) {
        [((UINotificationFeedbackGenerator *)_feedbackGenerator) notificationOccurred:UINotificationFeedbackTypeSuccess];
    }

};

@end
