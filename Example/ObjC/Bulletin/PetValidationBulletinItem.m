/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "PetValidationBulletinItem.h"
#import "BulletinDataSource.h"
#import "ImageCollectionViewCell.h"
#import "SelectionFeedbackGenerator.h"
#import "SuccessFeedbackGenerator.h"

@interface PetValidationBulletinItem ()

@property (nonatomic, strong) CollectionDataSource *dataSource;
@property (nonatomic, strong) SelectionFeedbackGenerator *selectionFeedbackGenerator;
@property (nonatomic, strong) SuccessFeedbackGenerator *successFeedbackGenerator;
@property (nonatomic, strong, nullable) UICollectionView *collectionView;

@end

@interface PetValidationBulletinItem (CollectionView) <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@end

@implementation PetValidationBulletinItem

- (instancetype)initWithDataSource:(CollectionDataSource *)data
{
    self = [super initWithTitle:@"Choose your Favorite"];
    if (self) {
        self.dataSource = data;
        self.selectionFeedbackGenerator = [[SelectionFeedbackGenerator alloc] init];
        self.successFeedbackGenerator = [[SuccessFeedbackGenerator alloc] init];
        self.collectionView = nil;
        self.descriptionText = [[NSString alloc] initWithFormat:@"You chose %@ as your favorite animal type. Here are a few examples of posts in this category.", [[data pluralizedPetName] lowercaseString]];
        self.actionButtonTitle = @"Validate";
        self.alternativeButtonTitle = @"Change";
    }
    return self;
}

- (NSArray<UIView *> *)makeViewsUnderDescriptionWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 1;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];

    BLTNContainerView *collectionWrapper = [interfaceBuilder wrapView:collectionView width:NULL height:@256 position:BLTNViewPositionPinnedToEdges];

    self.collectionView = collectionView;
    return @[collectionWrapper];

}

- (void)setUp
{
    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [super setUp];
}

- (void)tearDown
{
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

#pragma mark - Touch Events

- (void)actionButtonTappedWithSender:(UIButton *)sender
{
    // Play selection haptic feedback
    [self.selectionFeedbackGenerator prepare];
    [self.selectionFeedbackGenerator selectionChanged];

    // Display the loading indicator
    [self.manager displayActivityIndicatorWithColor:[UIColor blackColor]];

    // Wait for a "task" to complete before displaying the next item

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Play success haptic feedback
        [self.successFeedbackGenerator prepare];
        [self.successFeedbackGenerator notifySuccess];

        // Display next item
        self.nextItem = [BulletinDataSource makeCompletionPage];
        [self.manager displayNextItem];
    });
}

-(void)alternativeButtonTappedWithSender:(UIButton *)sender
{
    // Play selection haptic feedback
    [self.selectionFeedbackGenerator prepare];
    [self.selectionFeedbackGenerator selectionChanged];

    // Display previous item
    [self.manager popItem];
}

#pragma mark - Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [self.dataSource imageAtIndex:indexPath.row];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat squareSideLength = (collectionView.frame.size.width / 3) - 3;
    return CGSizeMake(squareSideLength, squareSideLength);
}

@end
