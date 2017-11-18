/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "SelectionFeedbackGenerator.h"

@implementation SelectionFeedbackGenerator {
    NSObject *_feedbackGenerator;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        if (@available(iOS 10.0, *)) {
            _feedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
        }

    }
    return self;
}

-(void)prepare {

    if (@available(iOS 10.0, *)) {
        [((UISelectionFeedbackGenerator *)_feedbackGenerator) prepare];
    }

};

-(void)selectionChanged {

    if (@available(iOS 10.0, *)) {
        [((UISelectionFeedbackGenerator *)_feedbackGenerator) selectionChanged];
    }

};

@end
