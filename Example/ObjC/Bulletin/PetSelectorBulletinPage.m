/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "PetSelectorBulletinPage.h"
#import "SelectionFeedbackGenerator.h"
#import "BulletinDataSource.h"
#import "CollectionDataSource.h"
#import "PetValidationBulletinItem.h"

@interface PetSelectorBulletinPage ()

@property (nonatomic, strong) UIButton *catButton;
@property (nonatomic, strong) UIButton *dogButton;
@property (nonatomic, strong) SelectionFeedbackGenerator *feedbackGenerator;

@end

@implementation PetSelectorBulletinPage

- (instancetype)init
{
    self = [super initWithTitle:@"Choose your Favorite"];
    if (self) {
        self.dismissable = NO;
        self.descriptionText = @"Your favorite pets will appear when you open the app.";
        self.feedbackGenerator = [[SelectionFeedbackGenerator alloc] init];
    }
    return self;
}

- (NSArray<UIView *> *)makeViewsUnderDescriptionWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder
{
    // We add choice cells to a group stack because they need less spacing
    UIStackView *petsStack = [interfaceBuilder makeGroupStackWithSpacing:16];
    NSInteger favoriteTabIndex = BulletinDataSource.favoriteTabIndex;

    // Cat button
    self.catButton = [self createChoiceCellWithDataSource:[[CatCollectionDataSource alloc] init] isSelected:favoriteTabIndex != 1];
    [petsStack addArrangedSubview:self.catButton];

    // Dog Button
    self.dogButton = [self createChoiceCellWithDataSource:[[DogCollectionDataSource alloc] init] isSelected:favoriteTabIndex == 1];
    [petsStack addArrangedSubview:self.dogButton];

    return @[petsStack];
}

#pragma mark - Custom Views

- (UIButton *)createChoiceCellWithDataSource:(CollectionDataSource *)dataSource isSelected:(BOOL)isSelected
{
    NSString *petName = dataSource.pluralizedPetName;
    NSString *buttonTitle = [[NSString alloc] initWithFormat:@"%@ %@", dataSource.emoji, petName];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.accessibilityLabel = petName;

    button.layer.cornerRadius = 12;
    button.layer.borderWidth = 2;

    [button setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self updateButtonAppearance:button forSelection:isSelected];

    if (isSelected) {
        self.nextItem = [[PetValidationBulletinItem alloc] initWithDataSource:dataSource];
    }

    return button;
}

- (void)updateButtonAppearance:(UIButton *)button forSelection:(BOOL)isSelected
{
    NSLayoutConstraint *height = [button.heightAnchor constraintEqualToConstant:55];
    height.priority = UILayoutPriorityDefaultHigh;
    height.active = YES;

    UIColor *buttonColor = isSelected ? self.appearance.actionButtonColor : [UIColor lightGrayColor];
    button.layer.borderColor = [buttonColor CGColor];
    [button setTitleColor:buttonColor forState:UIControlStateNormal];

    if (isSelected) {
        button.accessibilityTraits |= UIAccessibilityTraitSelected;
    } else {
        button.accessibilityTraits &= ~UIAccessibilityTraitSelected;
    }
}

- (void)setUp
{
    [self.catButton addTarget:self
                       action:@selector(catButtonTapped)
             forControlEvents:UIControlEventTouchUpInside];

    [self.dogButton addTarget:self
                        action:@selector(dogButtonTapped)
                forControlEvents:UIControlEventTouchUpInside];

    [super setUp];
}

- (void)tearDown
{
    [self.catButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.dogButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Touch Events

- (void)catButtonTapped
{
    // Play haptic feedback
    [self.feedbackGenerator prepare];
    [self.feedbackGenerator selectionChanged];

    // Update UI
    [self updateButtonAppearance:self.catButton forSelection:YES];
    [self updateButtonAppearance:self.dogButton forSelection:NO];

    // Notify the change
    [[NSNotificationCenter defaultCenter] postNotificationName:FavoriteTabIndexDidChangeNotificationName
                                                        object:self
                                                      userInfo:@{@"Index": @0}];

    // Set the next item
    self.nextItem = [[PetValidationBulletinItem alloc] initWithDataSource:[[CatCollectionDataSource alloc] init]];
}

- (void)dogButtonTapped
{
    // Play haptic feedback
    [self.feedbackGenerator prepare];
    [self.feedbackGenerator selectionChanged];

    // Update UI
    [self updateButtonAppearance:self.catButton forSelection:NO];
    [self updateButtonAppearance:self.dogButton forSelection:YES];

    // Notify the change
    [[NSNotificationCenter defaultCenter] postNotificationName:FavoriteTabIndexDidChangeNotificationName
                                                        object:self
                                                      userInfo:@{@"Index": @1}];

    // Set the next item
    self.nextItem = [[PetValidationBulletinItem alloc] initWithDataSource:[[DogCollectionDataSource alloc] init]];
}

- (void)actionButtonTappedWithSender:(UIButton *)sender
{
    // Play haptic feedback
    [self.feedbackGenerator prepare];
    [self.feedbackGenerator selectionChanged];

    // Ask the manager to present the next item
    [self.manager displayNextItem];
}

@end
