/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "ImageCollectionViewCell.h"

@interface ImageCollectionViewCell ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self performInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self performInit];
    }
    return self;
}

-(void)performInit
{
    self.imageView = [[UIImageView alloc] init];

    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];

    [self.contentView addSubview:_imageView];
    [[self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor] setActive:YES];
    [[self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor] setActive:YES];
    [[self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor] setActive:YES];
    [[self.contentView.bottomAnchor constraintEqualToAnchor:self.imageView.bottomAnchor] setActive:YES];
}

@end
