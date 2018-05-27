/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "CollectionDataSource.h"

@implementation CollectionDataSource

- (NSInteger)numberOfImages
{
    return 16;
}

- (NSString *)petName
{
    @throw [self requireConcreteImplementation];
}

- (NSString *)pluralizedPetName
{
    @throw [self requireConcreteImplementation];
}


-(NSString *)emoji
{
    @throw [self requireConcreteImplementation];
}

- (UIImage *)imageAtIndex:(NSInteger)index
{
    NSString *name = [NSString stringWithFormat:@"%@_img_%lx", [self petName], (unsigned long)index + 1];
    return [UIImage imageNamed:name];
}

- (NSException *)requireConcreteImplementation
{
    return [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Please use a concrete sublclass of CollectionDataSource"
                                 userInfo:NULL];
}

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
