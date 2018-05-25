/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import BLTNBoard;

@interface TextFieldBulletinPage : BLTNPageItem

@property (nonatomic, copy, nullable) void (^textInputHandler)(TextFieldBulletinPage *, NSString * _Nullable);
@property (nonatomic, strong, readonly, nonnull) UITextField *textField;

@end
