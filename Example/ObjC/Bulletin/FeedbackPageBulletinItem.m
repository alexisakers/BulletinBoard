/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "FeedbackPageBLTNItem.h"
#import "SelectionFeedbackGenerator.h"

@interface FeedbackPageBLTNItem ()

@property (nonatomic, strong) SelectionFeedbackGenerator *feedbackGenerator;

@end

@implementation FeedbackPageBLTNItem

- (void)actionButtonTappedWithSender:(UIButton *)sender
{
    // Play an haptic feedback
    [self.feedbackGenerator prepare];
    [self.feedbackGenerator selectionChanged];

    // Call super
    [super actionButtonTappedWithSender:sender];
}

- (void)alternativeButtonTappedWithSender:(UIButton *)sender
{
    // Play an haptic feedback
    [self.feedbackGenerator prepare];
    [self.feedbackGenerator selectionChanged];

    // Call super
    [super alternativeButtonTappedWithSender:sender];
}

@end
