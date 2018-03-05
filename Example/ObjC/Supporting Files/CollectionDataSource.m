/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "CollectionDataSource.h"

@implementation CollectionDataSource

- (UIImage *)imageAtIndex:(NSInteger)index {
    NSString *name = [NSString stringWithFormat:@"%@_img_%lx", [self petName], (unsigned long)index + 1];
    return [UIImage imageNamed:name];
};

- (int)numberOfImages {
    return 16;
}

- (NSString *)petName {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Please use a concrete sublclass of CollectionDataSource"
                                 userInfo:NULL];
}

- (NSString *)pluralizedPetName
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Please use a concrete sublclass of CollectionDataSource"
                                 userInfo:NULL];
}


-(NSString *)emoji
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Please use a concrete sublclass of CollectionDataSource"
                                 userInfo:NULL];
};

@end

@implementation DogCollectionDataSource

- (NSString *)petName {
    return @"dog";
}

- (NSString *)pluralizedPetName
{
    return @"Dogs";
}

- (NSString *)emoji
{
    return @"🐶";
}

@end

@implementation CatCollectionDataSource

- (NSString *)petName {
    return @"cat";
}
- (NSString *)pluralizedPetName
{
    return @"Cats";
}

- (NSString *)emoji
{
    return @"🐱";
}

@end
