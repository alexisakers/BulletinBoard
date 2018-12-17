/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "BLTNActionItem.h"
#import "BLTNBoardSwiftSupport.h"
#import <objc/message.h>

@interface BLTNActionItem ()

@property (nonatomic, strong, nullable, readwrite) UIButton *actionButton;
@property (nonatomic, strong, nullable, readwrite) UIButton *alternativeButton;

@end

@implementation BLTNActionItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.actionButtonTitle = nil;
        self.alternativeButtonTitle = nil;
        self.manager = nil;
        self.dismissable = YES;
        self.requiresCloseButton = YES;
        self.shouldStartWithActivityIndicator = NO;
        self.shouldRespondToKeyboardChanges = YES;
        self.nextItem = nil;
        self.presentationHandler = nil;
        self.dismissalHandler = nil;
        self.appearance = [[BLTNItemAppearance alloc] init];
        self.interfaceBuilderType = [BLTNInterfaceBuilder class];
        self.actionButton = nil;
        self.alternativeButton = nil;
        self.actionHandler = nil;
        self.alternativeHandler = nil;
    }
    return self;
}

#pragma mark - Properties

- (void)setActionButtonTitle:(NSString *)actionButtonTitle
{
    _actionButtonTitle = actionButtonTitle;
    if (self.actionButton) {
        [self.actionButton setTitle:actionButtonTitle forState:UIControlStateNormal];
    }
}

- (void)setAlternativeButtonTitle:(NSString *)alternativeButtonTitle
{
    _alternativeButtonTitle = alternativeButtonTitle;
    if (self.alternativeButton) {
        [self.alternativeButton setTitle:alternativeButtonTitle forState:UIControlStateNormal];
    }
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

- (NSArray<UIView *> *)makeFooterViewsWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder
{
    return nil;
}

- (NSArray<UIView *> *)makeContentViewsWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder
{
    return @[];
}

- (NSArray<UIView *> *)makeArrangedSubviews
{
    NSMutableArray<UIView *> *arrangedSubviews = [[NSMutableArray alloc] init];

    NSAssert([self.interfaceBuilderType isSubclassOfClass:[BLTNInterfaceBuilder class]],
             @"InterfaceBuilderType must be a subclass of BulletinInterfaceBuilder, or BulletinInterfaceBuilder.");

    BLTNInterfaceBuilder *interfaceBuilder = [[self.interfaceBuilderType alloc] initWithAppearance:self.appearance
                                                                                              item:self];

    NSArray<UIView *> *contentViews = [self makeContentViewsWithInterfaceBuilder:interfaceBuilder];
    [arrangedSubviews addObjectsFromArray:contentViews];

    // Buttons stack

    if (self.actionButtonTitle == nil && self.alternativeButtonTitle == nil) {
        return arrangedSubviews;
    }

    UIStackView *buttonsStack = [interfaceBuilder makeGroupStackWithSpacing:10];

    if (self.actionButtonTitle) {
        BLTNHighlightButtonWrapper *buttonWrapper = [interfaceBuilder makeActionButtonWithTitle:self.actionButtonTitle];
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
    
- (void)willDisplay
{
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
