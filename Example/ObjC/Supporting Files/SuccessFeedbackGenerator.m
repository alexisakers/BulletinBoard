/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "SuccessFeedbackGenerator.h"

@interface SuccessFeedbackGenerator ()

@property (nonatomic, strong, nullable) NSObject *feedbackGenerator;

@end

@implementation SuccessFeedbackGenerator

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 10.0, *)) {
            self.feedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
        }

    }
    return self;
}

- (void)prepare
{
    if (@available(iOS 10.0, *)) {
        [((UINotificationFeedbackGenerator *)self.feedbackGenerator) prepare];
    }
}

- (void)notifySuccess
{
    if (@available(iOS 10.0, *)) {
        [((UINotificationFeedbackGenerator *)self.feedbackGenerator) notificationOccurred:UINotificationFeedbackTypeSuccess];
    }
}

@end
