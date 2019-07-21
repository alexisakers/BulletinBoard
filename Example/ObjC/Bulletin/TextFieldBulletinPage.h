/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

@import UIKit;
@import BLTNBoard;

/**
 * A page item that displays a text field for user input.
 */

@interface TextFieldBulletinPage : BLTNPageItem

/// The block executed when the user finished inputting the text.
@property (nonatomic, nullable) void (^textInputHandler)(TextFieldBulletinPage * _Nonnull, NSString * _Nullable);

/// The text field presented by the page.
@property (nonatomic, strong, readonly, nullable) UITextField *textField;

/**
 * The method called to determine if the text is valid, and if the user can continue.
 * You can override this method to customize the validation process.
 */

- (BOOL)isValidInput:(NSString * _Nullable)text;

@end
