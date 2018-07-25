/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "BLTNPageItem.h"
#import "BLTNBoardSwiftSupport.h"

@interface BLTNPageItem ()

@property (nonatomic, nonnull, readwrite) NSString *title;
@property (nonatomic, nullable, readwrite) BLTNTitleLabelContainer *titleLabel;
@property (nonatomic, nullable, readwrite) UILabel *descriptionLabel;
@property (nonatomic, nullable, readwrite) UIImageView *imageView;

@end

@implementation BLTNPageItem

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

#pragma mark - View Updates

- (void)setDescriptionText:(NSString *)descriptionText
{
    _descriptionText = [descriptionText copy];
    if (self.attributedDescriptionText) {
        return;
    }
    if (self.descriptionLabel) {
        self.descriptionLabel.text = descriptionText;
    }
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    if (self.imageView) {
        self.imageView.image = image;
    }
}

- (void)setImageAccessibilityLabel:(NSString *)imageAccessibilityLabel
{
    _imageAccessibilityLabel = [imageAccessibilityLabel copy];
    if (self.imageView) {
        self.imageView.accessibilityLabel = imageAccessibilityLabel;
    }
}

- (void)setAttributedDescriptionText:(NSAttributedString *)attributedDescriptionText
{
    _attributedDescriptionText = [attributedDescriptionText copy];
    self.descriptionText = nil;
    if (self.descriptionLabel) {
        self.descriptionLabel.attributedText = attributedDescriptionText;
    }
}

#pragma mark - View Management

- (NSArray<UIView *> *)makeContentViewsWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder
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
    self.titleLabel.label.text = self.title;

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

    if (self.attributedDescriptionText) {
        self.descriptionLabel = [interfaceBuilder makeDescriptionLabel];
        self.descriptionLabel.attributedText = self.attributedDescriptionText;
        [contentViews addObject:self.descriptionLabel];
        insertComplementaryViews(@selector(makeViewsUnderDescriptionWithInterfaceBuilder:));

    } else if (self.descriptionText) {
        self.descriptionLabel = [interfaceBuilder makeDescriptionLabel];
        self.descriptionLabel.text = self.descriptionText;
        [contentViews addObject:self.descriptionLabel];
        insertComplementaryViews(@selector(makeViewsUnderDescriptionWithInterfaceBuilder:));
    }

    return contentViews;

}

#pragma mark - Customization

- (NSArray<UIView *> *)makeHeaderViewsWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder
{
    return nil;
}

- (NSArray<UIView *> *)makeViewsUnderTitleWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder
{
    return nil;
}

- (NSArray<UIView *> *)makeViewsUnderImageWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder
{
    return nil;
}

- (NSArray<UIView *> *)makeViewsUnderDescriptionWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder
{
    return nil;
}

@end
