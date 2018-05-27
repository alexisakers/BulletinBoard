/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import BLTNBoard;

#import "CollectionDataSource.h"

/**
 * A bulletin page that allows the user to validate its selection.
 *
 * This item demonstrates popping to the previous item, and including a collection view inside the card.
 */

@interface PetValidationBulletinItem : BLTNPageItem

- (instancetype)initWithDataSource:(CollectionDataSource *)data;

@end
