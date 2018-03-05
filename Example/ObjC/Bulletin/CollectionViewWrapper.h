/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * A view that provides an fixed-height collection view.
 */

@interface CollectionViewWrapper : UIView

/// The collection view wrapped by the view.
@property (nonatomic, nonnull, strong, readonly) UICollectionView *collectionView;

/// The height of the collection view. Defaults to 256. You can change this value at runtime.
@property (nonatomic) CGFloat contentHeight;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@end

NS_ASSUME_NONNULL_END
