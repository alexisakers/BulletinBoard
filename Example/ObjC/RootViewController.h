/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import BLTNBoard;

/**
 * A view controller displaying a set of images.
 *
 * This demonstrates how to set up a bulletin manager and present the bulletin.
 */

@interface RootViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *styleButtonItem;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *showIntoButtonItem;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

- (IBAction)styleButtonTapped:(id)sender;
- (IBAction)showIntroButtonTapped:(id)sender;
- (IBAction)tabIndexChanged:(UISegmentedControl *)sender;

@end

