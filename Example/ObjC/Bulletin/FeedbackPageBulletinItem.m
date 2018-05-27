/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "FeedbackPageBulletinItem.h"
#import "SelectionFeedbackGenerator.h"

@interface FeedbackPageBulletinItem ()

@property (nonatomic, strong) SelectionFeedbackGenerator *feedbackGenerator;

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

- (void)alternativeButtonTappedWithSender:(UIButton *)sender
{
    // Play an haptic feedback
    [self.feedbackGenerator prepare];
    [self.feedbackGenerator selectionChanged];

    // Call super
    [super alternativeButtonTappedWithSender:sender];
}

@end
