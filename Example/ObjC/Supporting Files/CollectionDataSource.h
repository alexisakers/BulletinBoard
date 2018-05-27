/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;

/**
 * A data provider for a collection view.
 */

@interface CollectionDataSource : NSObject

/// The number of images on the data set.
@property (nonatomic, readonly) NSInteger numberOfImages;

/// The name of the pet.
@property (nonatomic, copy, readonly) NSString *petName;

/// The pluralized name of the pet.
@property (nonatomic, copy, readonly) NSString *pluralizedPetName;

/// The emoji for the animal.
@property (nonatomic, copy, readonly) NSString *emoji;

/// Get the image at the given index.
- (UIImage *)imageAtIndex:(NSInteger)index;

@end

@interface DogCollectionDataSource : CollectionDataSource
@end

@interface CatCollectionDataSource : CollectionDataSource
@end
