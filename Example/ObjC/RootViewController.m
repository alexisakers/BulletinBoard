/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "RootViewController.h"
#import "ImageCollectionViewCell.h"
#import "BulletinDataSource.h"
#import "CollectionDataSource.h"
#import "BackgroundViewStyle.h"

@interface RootViewController ()

@property (nonatomic, strong) CollectionDataSource *dataSource;
@property (nonatomic, strong) BLTNItemManager *bulletinManager;
@property (nonatomic, strong) NSArray<BackgroundViewStyle *> *backgroundStyles;
@property (nonatomic, strong) BackgroundViewStyle *currentBackground;
@property (nonatomic) BOOL shouldHideStatusBar;

@end

@implementation RootViewController

#pragma mark View

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self reloadManager];
    self.backgroundStyles = BackgroundViewStyle.allStyles;
    self.currentBackground = BackgroundViewStyle.defaultStyle;
    self.shouldHideStatusBar = NO;

    // Finish Initialization

    NSInteger favoriteTab = BulletinDataSource.favoriteTabIndex;
    self.segmentedControl.selectedSegmentIndex = favoriteTab;
    self.dataSource = favoriteTab == 0 ?
        [[CatCollectionDataSource alloc] init] : [[DogCollectionDataSource alloc] init];

    self.styleButtonItem.title = self.currentBackground.name;

    // Set up the collection view

    [self.collectionView registerClass:[ImageCollectionViewCell class]
            forCellWithReuseIdentifier:@"cell"];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    UILayoutGuide *guide = self.view.readableContentGuide;
    [[self.collectionView.leadingAnchor constraintEqualToAnchor:[guide leadingAnchor]] setActive:YES];
    [[self.collectionView.trailingAnchor constraintEqualToAnchor:[guide trailingAnchor]] setActive:YES];
    [[self.collectionView.topAnchor constraintEqualToAnchor:[guide topAnchor]] setActive:YES];

    UIEdgeInsets cvInset = UIEdgeInsetsMake(8, self.collectionView.contentInset.left,
                                            8, self.collectionView.contentInset.right);

    self.collectionView.contentInset = cvInset;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self prepareForBulletin];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Bulletin

/**
 * Prepares the view controller for the bulletin interface.
 */

- (void)prepareForBulletin
{
    // Register notification observers

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupDidComplete)
                                                 name:SetupDidCompleteNotificationName object:NULL];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(favoriteIndexDidChangeWithNotification:) name:FavoriteTabIndexDidChangeNotificationName
                                               object:NULL];

    // Add toolbar items

    [[self navigationController] setToolbarHidden:NO];

    UIBarButtonItem *fontItem = [[UIBarButtonItem alloc] initWithTitle:[BulletinDataSource currentFontName]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(fontButtonTapped:)];

    UIBarButtonItem *statusBarItem = [[UIBarButtonItem alloc] initWithTitle:self.shouldHideStatusBar ? @"Status Bar: OFF" : @"Status Bar: ON"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(fullScreenButtonTapped:)];
    self.toolbarItems = @[fontItem, statusBarItem];

    // If the user did not complete the setup, present the bulletin automatically

    if (BulletinDataSource.userDidCompleteSetup == NO) {
        [self showBulletin];
    }
}

- (void)showBulletin
{
    self.bulletinManager.backgroundViewStyle = self.currentBackground.style;

    if (self.shouldHideStatusBar == YES) {
        self.bulletinManager.statusBarAppearance = BLTNStatusBarAppearanceHidden;
    } else {
        self.bulletinManager.statusBarAppearance = BLTNStatusBarAppearanceAutomatic;
    }

    [self.bulletinManager showBulletinAboveViewController:self animated:YES completion:NULL];
}

- (void)reloadManager
{
    BLTNPageItem *introPage = [BulletinDataSource makeIntroPage];
    self.bulletinManager = [[BLTNItemManager alloc] initWithRootItem:introPage];
}

#pragma mark Notifications

- (void)setupDidComplete
{
    [BulletinDataSource setUserDidCompleteSetup:YES];
}

- (void)favoriteIndexDidChangeWithNotification:(NSNotification *)notification
{
    NSNumber *intValue = (NSNumber *)[[notification userInfo] objectForKey:@"Index"];
    if (intValue != nil) {
        [self updateTabWithNewIndex:intValue];
    }

}

- (void)updateTabWithNewIndex:(NSNumber *)newIndex
{
    NSInteger integerValue = newIndex.integerValue;

    if (integerValue) {
        self.dataSource = [[DogCollectionDataSource alloc] init];
    } else {
        integerValue = 0;
        self.dataSource = [[CatCollectionDataSource alloc] init];
    }

    self.segmentedControl.selectedSegmentIndex = integerValue;
    BulletinDataSource .favoriteTabIndex = integerValue;
    [self.collectionView reloadData];
}

#pragma mark Button Actions

- (IBAction)styleButtonTapped:(id)sender
{
    UIAlertController *styleSelectorSheet = [UIAlertController alertControllerWithTitle:@"Bulletin Background Style"
                                                                                message:NULL preferredStyle:UIAlertControllerStyleActionSheet];

    for (BackgroundViewStyle *background in self.backgroundStyles) {

        UIAlertAction *action = [UIAlertAction actionWithTitle:background.name
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self.styleButtonItem setTitle:background.name];
                                                           self.currentBackground = background;
                                                       }];

        BOOL isSelected = [background.name isEqualToString:self.currentBackground.name];
        NSNumber *checked = [NSNumber numberWithBool:isSelected];
        [action setValue:checked forKey:@"checked"];

        [styleSelectorSheet addAction:action];

    }

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];

    [styleSelectorSheet addAction:cancelAction];

    [[styleSelectorSheet popoverPresentationController] setBarButtonItem:self.styleButtonItem];

    [self presentViewController:styleSelectorSheet animated:YES completion:NULL];
}

- (IBAction)showIntroButtonTapped:(id)sender
{
    [self showBulletin];
}

- (IBAction)tabIndexChanged:(UISegmentedControl *)sender
{
    [self updateTabWithNewIndex:[NSNumber numberWithInteger:sender.selectedSegmentIndex]];
}

- (void)fontButtonTapped:(UIBarButtonItem *)sender
{
    [BulletinDataSource setUseAvenirFont:![BulletinDataSource useAvenirFont]];
    sender.title = BulletinDataSource.currentFontName;
    [self reloadManager];
}

- (void)fullScreenButtonTapped:(UIBarButtonItem *)sender
{
    self.shouldHideStatusBar = !(self.shouldHideStatusBar);
    sender.title = self.shouldHideStatusBar ? @"Status Bar: OFF" : @"Status Bar: On";
    [self reloadManager];
}

#pragma mark Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfImages];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    UIImage *image = [self.dataSource imageAtIndex:[indexPath row]];
    cell.imageView.image = image;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [self.dataSource imageAtIndex:[indexPath row]];
    CGFloat width = collectionView.frame.size.width;

    if (!image) {
        return CGSizeMake(width, 0);
    }

    CGFloat aspectRatio = image.size.height / image.size.width;
    CGFloat height = width * aspectRatio;

    return CGSizeMake(width, height);
}

@end
