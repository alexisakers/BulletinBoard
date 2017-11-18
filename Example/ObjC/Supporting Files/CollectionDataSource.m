/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "CollectionDataSource.h"

@implementation CollectionDataSource

/// Get the image at the given index.
-(UIImage *)imageAtIndex:(NSInteger)index {
    NSString *name = [NSString stringWithFormat:@"%@_img_%lx", [self petName], (unsigned long)index + 1];
    return [UIImage imageNamed:name];
};

/// The number of images on the data set.
-(int)numberOfImages {
    return 16;
};

/// The name of the pet.
-(NSString *)petName {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Please use a concrete sublclass of CollectionDataSource"
                                 userInfo:NULL];
};

@end

@implementation DogCollectionDataSource

-(NSString *)petName {
    return @"dog";
}

@end

@implementation CatCollectionDataSource

-(NSString *)petName {
    return @"cat";
}

@end
