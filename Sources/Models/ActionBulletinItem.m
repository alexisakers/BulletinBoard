/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "ActionBulletinItem.h"
#import <objc/message.h>
#import <BulletinBoard/BulletinBoard-Swift.h>

@interface ActionBulletinItem ()

@property (nonatomic, strong, nullable, readwrite) UIButton *actionButton;
@property (nonatomic, strong, nullable, readwrite) UIButton *alternativeButton;

@end

@implementation ActionBulletinItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.actionButtonTitle = nil;
        self.alternativeButtonTitle = nil;
        self.manager = nil;
        self.dismissable = YES;
        self.shouldStartWithActivityIndicator = NO;
        self.shouldRespondToKeyboardChanges = YES;
        self.nextItem = nil;
        self.presentationHandler = nil;
        self.dismissalHandler = nil;
        self.appearance = [[BulletinAppearance alloc] init];
        self.interfaceBuilderType = [BulletinInterfaceBuilder class];
        self.actionButton = nil;
        self.alternativeButton = nil;
        self.actionHandler = nil;
        self.alternativeHandler = nil;
    }
    return self;
}

#pragma mark - Buttons

- (void)actionButtonTappedWithSender:(UIButton *)sender
{
    if (self.actionHandler) {
        self.actionHandler(self);
    }
}

- (void)alternativeButtonTappedWithSender:(UIButton *)sender
{
    if (self.alternativeHandler) {
        self.alternativeHandler(self);
    }
}

#pragma mark - View Management

- (NSArray<UIView *> *)makeFooterViewsWithInterfaceBuilder:(BulletinInterfaceBuilder *)interfaceBuilder
{
    return nil;
}

- (NSArray<UIView *> *)makeContentViewsWithInterfaceBuilder:(BulletinInterfaceBuilder *)interfaceBuilder
{
    return @[];
}

- (NSArray<UIView *> *)makeArrangedSubviews
{
    NSMutableArray<UIView *> *arrangedSubviews = [[NSMutableArray alloc] init];

    NSAssert([self.interfaceBuilderType isSubclassOfClass:[BulletinInterfaceBuilder class]],
             @"InterfaceBuilderType must be a subclass of BulletinInterfaceBuilder, or BulletinInterfaceBuilder.");

    BulletinInterfaceBuilder *interfaceBuilder = [[self.interfaceBuilderType alloc] initWithAppearance:self.appearance];
    
    NSArray<UIView *> *contentViews = [self makeContentViewsWithInterfaceBuilder:interfaceBuilder];
    [arrangedSubviews addObjectsFromArray:contentViews];

    // Buttons stack

    if (self.actionButtonTitle == nil && self.alternativeButtonTitle == nil) {
        return arrangedSubviews;
    }

    UIStackView *buttonsStack = [interfaceBuilder makeGroupStackWithSpacing:10];

    if (self.actionButtonTitle) {
        HighlightButtonWrapper *buttonWrapper = [interfaceBuilder makeActionButtonWithTitle:self.actionButtonTitle];
        [buttonsStack addArrangedSubview:buttonWrapper];
        self.actionButton = buttonWrapper.button;
    }

    if (self.alternativeButtonTitle) {
        UIButton *button = [interfaceBuilder makeAlternativeButtonWithTitle:self.alternativeButtonTitle];
        [buttonsStack addArrangedSubview:button];
        self.alternativeButton = button;
    }

    [arrangedSubviews addObject:buttonsStack];

    // Footer

    NSArray<UIView *> *footerViews = [self makeFooterViewsWithInterfaceBuilder:interfaceBuilder];

    if (footerViews) {
        [arrangedSubviews addObjectsFromArray:footerViews];
    }

    return arrangedSubviews;
}

#pragma mark - Events

- (void)setUp
{
    [self.actionButton addTarget:self
                          action:@selector(actionButtonTappedWithSender:)
                forControlEvents:UIControlEventTouchUpInside];

    [self.alternativeButton addTarget:self
                               action:@selector(alternativeButtonTappedWithSender:)
                     forControlEvents:UIControlEventTouchUpInside];
}

- (void)tearDown
{
    [self.actionButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.alternativeButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    self.actionButton = nil;
    self.alternativeButton = nil;
}

- (void)onDisplay
{
    if (self.presentationHandler) {
        self.presentationHandler(self);
    }
}

- (void)onDismiss
{
    if (self.dismissalHandler) {
        self.dismissalHandler(self);
    }
}

@end
