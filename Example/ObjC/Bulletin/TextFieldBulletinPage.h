/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import BulletinBoard;

@interface TextFieldBulletinPage : NSObject <BulletinItem, UITextFieldDelegate>

@property (nonatomic, copy, nullable) void (^actionHandler)(TextFieldBulletinPage* _Nonnull);

@end
