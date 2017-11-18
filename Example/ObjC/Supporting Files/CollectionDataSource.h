/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;

/**
 * A data provider for a collection view.
 */

@interface CollectionDataSource : NSObject

/// Get the image at the given index.
-(UIImage *)imageAtIndex:(NSInteger)index;

/// The number of images on the data set.
-(int)numberOfImages;

/// The name of the pet.
-(NSString *)petName;

@end

@interface DogCollectionDataSource : CollectionDataSource
@end

@interface CatCollectionDataSource : CollectionDataSource
@end
