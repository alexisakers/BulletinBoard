/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "SelectionFeedbackGenerator.h"

@interface SelectionFeedbackGenerator ()

@property (nonatomic, strong, nullable) NSObject *feedbackGenerator;

@end

@implementation SelectionFeedbackGenerator

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 10.0, *)) {
            self.feedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
        }
    }
    return self;
}

- (void)prepare {
    if (@available(iOS 10.0, *)) {
        [((UISelectionFeedbackGenerator *)self.feedbackGenerator) prepare];
    }
}

- (void)selectionChanged {
    if (@available(iOS 10.0, *)) {
        [((UISelectionFeedbackGenerator *)self.feedbackGenerator) selectionChanged];
    }
}

@end
