/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell {
    UIImageView *_imageView;
}

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

-(void)performInit {

    _imageView = [[UIImageView alloc] init];

    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];

    [self.contentView addSubview:_imageView];
    [[_imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor] setActive:YES];
    [[_imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor] setActive:YES];
    [[_imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor] setActive:YES];
    [[self.contentView.bottomAnchor constraintEqualToAnchor:_imageView.bottomAnchor] setActive:YES];

};

@end
