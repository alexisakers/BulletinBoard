/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "RootViewController.h"
#import "ImageCollectionViewCell.h"
#import "BulletinDataSource.h"
#import "CollectionDataSource.h"
#import "BackgroundViewStyle.h"

@implementation RootViewController {
    CollectionDataSource *_dataSource;
    BulletinManager *_bulletinManager;
    NSArray<BackgroundViewStyle *> *_backgroundStyles;
    BackgroundViewStyle *_currentBackground;
    BOOL _shouldHideStatusBar;
}

@synthesize styleButtonItem;
@synthesize segmentedControl;
@synthesize showIntoButtonItem;
@synthesize collectionView;

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];

    [self reloadManager];
    _backgroundStyles = [BackgroundViewStyle allStyles];
    _currentBackground = [BackgroundViewStyle defaultStyle];
    _shouldHideStatusBar = NO;

    // Finish Initialization

    NSInteger favoriteTab = [BulletinDataSource favoriteTabIndex];
    [segmentedControl setSelectedSegmentIndex:favoriteTab];
    _dataSource = favoriteTab == 0 ?
        [[CatCollectionDataSource alloc] init] : [[DogCollectionDataSource alloc] init];

    [styleButtonItem setTitle:_currentBackground.name];

    // Set up the collection view

    [collectionView registerClass:[ImageCollectionViewCell class]
       forCellWithReuseIdentifier:@"cell"];

    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];

    UILayoutGuide *guide = self.view.readableContentGuide;
    [[[collectionView leadingAnchor] constraintEqualToAnchor:[guide leadingAnchor]] setActive:YES];
    [[[collectionView trailingAnchor] constraintEqualToAnchor:[guide trailingAnchor]] setActive:YES];
    [[[collectionView topAnchor] constraintEqualToAnchor:[guide topAnchor]] setActive:YES];

    UIEdgeInsets cvInset = UIEdgeInsetsMake(8, collectionView.contentInset.left, 8, collectionView.contentInset.right);
    [collectionView setContentInset:cvInset];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self prepareForBulletin];
};

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Bulletin

/**
 * Prepares the view controller for the bulletin interface.
 */

-(void)prepareForBulletin {

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

    UIBarButtonItem *statusBarItem = [[UIBarButtonItem alloc] initWithTitle:_shouldHideStatusBar ? @"Status Bar: OFF" : @"Status Bar: ON"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(fullScreenButtonTapped:)];
    [self setToolbarItems:@[fontItem, statusBarItem]];

    // If the user did not complete the setup, present the bulletin automatically

    if ([BulletinDataSource userDidCompleteSetup] == NO) {
        [self showBulletin];
    }

};

-(void)showBulletin {

    [_bulletinManager setBackgroundViewStyle:[_currentBackground style]];

    if (_shouldHideStatusBar == YES) {
        [_bulletinManager setStatusBarAppearance:BulletinStatusBarAppearanceHidden];
    } else {
        [_bulletinManager setStatusBarAppearance:BulletinStatusBarAppearanceAutomatic];
    }

    [_bulletinManager prepare];
    [_bulletinManager presentBulletinAboveViewController:self
                                                animated:YES
                                              completion:NULL];

};

-(void)reloadManager {

    PageBulletinItem *introPage = [BulletinDataSource makeIntroPage];
    _bulletinManager = [[BulletinManager alloc] initWithRootItem:introPage];

};

#pragma mark Notifications

-(void)setupDidComplete {
    [BulletinDataSource setUserDidCompleteSetup:YES];
};

-(void)favoriteIndexDidChangeWithNotification:(NSNotification *)notification {

    NSNumber *intValue = (NSNumber *)[[notification userInfo] objectForKey:@"Index"];

    if (intValue) {
        [self updateTabWithNewIndex:intValue];
    }

};

-(void)updateTabWithNewIndex:(NSNumber *)newIndex {

    NSInteger integerValue = newIndex.integerValue;

    if (integerValue) {
        _dataSource = [[DogCollectionDataSource alloc] init];
    } else {
        integerValue = 0;
        _dataSource = [[CatCollectionDataSource alloc] init];
    }

    segmentedControl.selectedSegmentIndex = integerValue;
    [BulletinDataSource setFavoriteTabIndex:integerValue];
    [collectionView reloadData];

};

#pragma mark Button Actions

-(IBAction)styleButtonTapped:(id)sender {

    UIAlertController *styleSelectorSheet = [UIAlertController alertControllerWithTitle:@"Bulletin Background Style"
                                                                                message:NULL preferredStyle:UIAlertControllerStyleActionSheet];

    for (BackgroundViewStyle *background in _backgroundStyles) {

        UIAlertAction *action = [UIAlertAction actionWithTitle: background.name
                                                         style: UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                             [self.styleButtonItem setTitle:background.name];
                                                             self->_currentBackground = background;
                                                       }];

        BOOL isSelected = [background.name isEqualToString:_currentBackground.name];
        NSNumber *checked = [NSNumber numberWithBool:isSelected];
        [action setValue:checked forKey:@"checked"];

        [styleSelectorSheet addAction:action];

    }

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];

    [styleSelectorSheet addAction:cancelAction];

    [[styleSelectorSheet popoverPresentationController] setBarButtonItem:styleButtonItem];

    [self presentViewController:styleSelectorSheet animated:YES completion:NULL];

};

-(IBAction)showIntroButtonTapped:(id)sender {
    [self showBulletin];
};

-(IBAction)tabIndexChanged:(UISegmentedControl *)sender {
    [self updateTabWithNewIndex:[NSNumber numberWithInteger:sender.selectedSegmentIndex]];
};

-(void)fontButtonTapped:(UIBarButtonItem *)sender {
    [BulletinDataSource setUseAvenirFont:![BulletinDataSource useAvenirFont]];
    [sender setTitle:[BulletinDataSource currentFontName]];
    [self reloadManager];
}

-(void)fullScreenButtonTapped:(UIBarButtonItem *)sender {
    _shouldHideStatusBar = !(_shouldHideStatusBar);
    NSString *newTitle = _shouldHideStatusBar ? @"Status Bar: OFF" : @"Status Bar: On";
    [sender setTitle:newTitle];
    [self reloadManager];
}

#pragma mark Collection View

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource numberOfImages];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    UIImage *image = [_dataSource imageAtIndex:[indexPath row]];
    [cell.imageView setImage: image];

    return cell;

};

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    UIImage *image = [_dataSource imageAtIndex:[indexPath row]];
    CGFloat width = collectionView.frame.size.width;

    if (!image) {
        return CGSizeMake(width, 0);
    }

    CGFloat aspectRatio = image.size.height / image.size.width;
    CGFloat height = width * aspectRatio;

    return CGSizeMake(width, height);

};

@end
