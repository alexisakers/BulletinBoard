/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "BLTNActionItem.h"
#import "BLTNBoardSwiftSupport.h"

@interface BLTNActionItem ()

@property (nonatomic, strong, nullable, readwrite) UIButton *actionButton;
@property (nonatomic, strong, nullable, readwrite) UIButton *alternateActionButton;

@end

@implementation BLTNActionItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dismissable = YES;
        self.showsCloseButton = YES;
        self.shouldStartWithActivityIndicator = NO;
        self.shouldRespondToKeyboardChanges = YES;
        self.appearance = [[BLTNItemAppearance alloc] init];
        self.interfaceBuilderType = [BLTNInterfaceBuilder class];
    }
    return self;
}

#pragma mark - Properties

- (void)setActionTitle:(NSString *)actionTitle
{
    _actionTitle = actionTitle;
    if (self.actionButton) {
        [self.actionButton setTitle:actionTitle forState:UIControlStateNormal];
    }
}

- (void)setAlternateActionTitle:(NSString *)alternateActionTitle
{
    _alternateActionTitle = alternateActionTitle;
    if (self.alternateActionButton) {
        [self.alternateActionButton setTitle:alternateActionTitle forState:UIControlStateNormal];
    }
}

#pragma mark - Buttons

- (void)actionButtonTappedWithSender:(UIButton *)sender
{
    if (self.actionHandler) {
        self.actionHandler(self);
    }
}

- (void)alternateActionButtonTappedWithSender:(UIButton *)sender
{
    if (self.alternateActionHandler) {
        self.alternateActionHandler(self);
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

    if (self.actionTitle == nil && self.alternateActionTitle == nil) {
        return arrangedSubviews;
    }

    UIStackView *buttonsStack = [interfaceBuilder makeGroupStackWithSpacing:10];

    if (self.actionTitle) {
        BLTNHighlightButtonWrapper *buttonWrapper = [interfaceBuilder makeActionButtonWithTitle:self.actionTitle];
        [buttonsStack addArrangedSubview:buttonWrapper];
        self.actionButton = buttonWrapper.button;
    }

    if (self.alternateActionTitle) {
        UIButton *button = [interfaceBuilder makeAlternativeButtonWithTitle:self.alternateActionTitle];
        [buttonsStack addArrangedSubview:button];
        self.alternateActionButton = button;
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
    [super setUp];
    [self.actionButton addTarget:self
                          action:@selector(actionButtonTappedWithSender:)
                forControlEvents:UIControlEventTouchUpInside];

    [self.alternateActionButton addTarget:self
                                   action:@selector(alternateActionButtonTappedWithSender:)
                         forControlEvents:UIControlEventTouchUpInside];
}

- (void)tearDown
{
    [super tearDown];
    [self.actionButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    self.actionButton = nil;
    [self.alternateActionButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    self.alternateActionButton = nil;
}
    
- (void)willPresent
{
    [super willPresent];
    if (self.willPresentHandler) {
        self.willPresentHandler(self);
    }
}

- (void)didPresent
{
    [super didPresent];
    if (self.didPresentHandler) {
        self.didPresentHandler(self);
    }
}

- (void)willDismiss
{
    [super willDismiss];
    if (self.willDismissHandler) {
        self.willDismissHandler(self);
    }
}

- (void)didDismiss
{
    [super didDismiss];
    if (self.didDismissHandler) {
        self.didDismissHandler(self);
    }
}

@end
