/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

#import "TextFieldBulletinPage.h"

@interface TextFieldBulletinPage () <UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UITextField *textField;

@end

@implementation TextFieldBulletinPage

- (NSArray<UIView *> *)makeViewsUnderDescriptionWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder
{
    self.textField = [interfaceBuilder makeTextFieldWithPlaceholder:@"Full Name"
                                                          returnKey:UIReturnKeyJoin
                                                           delegate:self];
    return @[self.textField];
}

- (void)onDisplay
{
    // Uncomment to start typing when the bulletin item is presented
    // [self.textField becomeFirstResponder];
}

- (void)tearDown
{
    [self.textField setDelegate:nil];
}

#pragma mark UITextFieldDelegate

- (void)actionButtonTappedWithSender:(UIButton *)sender
{
    [self textFieldShouldReturn:self.textField];
    [super actionButtonTappedWithSender:sender];
}

- (BOOL)isValidInput:(NSString *)text
{
    return text != NULL && text.length > 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self isValidInput:textField.text]) {
        if (self.textInputHandler) {
            self.textInputHandler(self, textField.text);
        }
    } else {
        UIColor *redColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
        self.descriptionLabel.textColor = [UIColor redColor];
        self.descriptionLabel.text = @"You must enter a valid name to continue.";
        self.textField.backgroundColor = redColor;
    }
}

@end
