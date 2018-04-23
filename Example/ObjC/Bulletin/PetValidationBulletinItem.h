/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import Bulletin;

#import "CollectionDataSource.h"

/**
 * A bulletin page that allows the user to validate its selection.
 *
 * This item demonstrates popping to the previous item, and including a collection view inside the card.
 */

@interface PetValidationBulletinItem : BLTNPageItem

- (instancetype)initWithDataSource:(CollectionDataSource *)data;

@end
