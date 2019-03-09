/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "FeedbackPageBulletinItem.h"

@interface FeedbackPageBulletinItem ()

@property (nonatomic, strong) UISelectionFeedbackGenerator *feedbackGenerator;

@end

@implementation FeedbackPageBulletinItem

- (void)actionButtonTappedWithSender:(UIButton *)sender
{
    // Play an haptic feedback
    [self.feedbackGenerator prepare];
    [self.feedbackGenerator selectionChanged];

    // Call super
    [super actionButtonTappedWithSender:sender];
}

- (void)alternateActionButtonTappedWithSender:(UIButton *)sender
{
    // Play an haptic feedback
    [self.feedbackGenerator prepare];
    [self.feedbackGenerator selectionChanged];

    // Call super
    [super alternateActionButtonTappedWithSender:sender];
}

@end
