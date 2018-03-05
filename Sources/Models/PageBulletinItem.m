/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "PageBulletinItem.h"
#import <BulletinBoard/BulletinBoard-Swift.h>

@interface PageBulletinItem ()

@property (nonatomic, nonnull, readwrite) NSString *title;
@property (nonatomic, nullable, readwrite) UILabel *titleLabel;
@property (nonatomic, nullable, readwrite) UILabel *descriptionLabel;
@property (nonatomic, nullable, readwrite) UIImageView *imageView;

@end

@implementation PageBulletinItem

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = nil;
        self.imageAccessibilityLabel = nil;
        self.descriptionText = nil;
        self.titleLabel = nil;
        self.descriptionLabel = nil;
        self.imageView = nil;
    }
    return self;
}

#pragma mark - View Management

- (NSArray<UIView *> *)makeContentViewsWithInterfaceBuilder:(BulletinInterfaceBuilder *)interfaceBuilder
{
    NSMutableArray<UIView *> *contentViews = [[NSMutableArray alloc] init];

    void (^insertComplementaryViews)(SEL) = ^(SEL generator) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSObject *result = [self performSelector:generator withObject:interfaceBuilder];
#pragma clang diagnostic pop
        
        if ([result isKindOfClass:[NSArray<UIView *> class]]) {
            [contentViews addObjectsFromArray:(NSArray<UIView *> *)result];
        }
    };

    insertComplementaryViews(@selector(makeHeaderViewsWithInterfaceBuilder:));

    // Title label

    self.titleLabel = [interfaceBuilder makeTitleLabel];
    self.titleLabel.text = self.title;

    [contentViews addObject:self.titleLabel];
    insertComplementaryViews(@selector(makeViewsUnderTitleWithInterfaceBuilder:));

    // Image View

    if (self.image) {

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = self.image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tintColor = self.appearance.imageViewTintColor;

        if (self.imageAccessibilityLabel) {
            imageView.isAccessibilityElement = YES;
            imageView.accessibilityLabel = self.imageAccessibilityLabel;
        }

        self.imageView = imageView;
        [contentViews addObject:imageView];

        insertComplementaryViews(@selector(makeViewsUnderImageWithInterfaceBuilder:));

    }

    // Description Label

    if (self.descriptionText) {
        self.descriptionLabel = [interfaceBuilder makeDescriptionLabel];
        self.descriptionLabel.text = self.descriptionText;
        [contentViews addObject:self.descriptionLabel];
        insertComplementaryViews(@selector(makeViewsUnderDescriptionWithInterfaceBuilder:));
    }

    return contentViews;

}

#pragma mark - Customization

- (NSArray<UIView *> *)makeHeaderViewsWithInterfaceBuilder:(BulletinInterfaceBuilder *)interfaceBuilder
{
    return nil;
}

- (NSArray<UIView *> *)makeViewsUnderTitleWithInterfaceBuilder:(BulletinInterfaceBuilder *)interfaceBuilder
{
    return nil;
}

- (NSArray<UIView *> *)makeViewsUnderImageWithInterfaceBuilder:(BulletinInterfaceBuilder *)interfaceBuilder
{
    return nil;
}

- (NSArray<UIView *> *)makeViewsUnderDescriptionWithInterfaceBuilder:(BulletinInterfaceBuilder *)interfaceBuilder
{
    return nil;
}

@end
