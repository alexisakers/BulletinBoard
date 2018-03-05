/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "CollectionViewWrapper.h"

@interface CollectionViewWrapper ()

@property (nonatomic, nonnull, strong, readwrite) UICollectionView *collectionView;

@end

@implementation CollectionViewWrapper

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.contentHeight = 256.0;
        self.collectionView = collectionView;
        [self addSubview:collectionView];
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;

        [collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        [collectionView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;

        [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return self;
}

- (void)setContentHeight:(CGFloat)contentHeight
{
    _contentHeight = contentHeight;
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize
{
    // use 0 to have a flexible width, and use the fixed height
    return CGSizeMake(0, self.contentHeight);
}

@end
