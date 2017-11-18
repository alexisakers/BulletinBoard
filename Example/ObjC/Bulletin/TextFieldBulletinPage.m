/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "TextFieldBulletinPage.h"

@implementation TextFieldBulletinPage {
    UILabel *_descriptionLabel;
    UITextField *_textField;
    BulletinInterfaceFactory *_interfaceFactory;
}

@synthesize nextItem;
@synthesize manager;
@synthesize isDismissable;
@synthesize dismissalHandler;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _interfaceFactory = [[BulletinInterfaceFactory alloc] init];
    }
    return self;
}

-(NSArray<UIView *> * _Nonnull)makeArrangedSubviews {

    NSMutableArray<UIView *> *arrangedSubviews = [NSMutableArray array];

    // Title Label

    UILabel *titleLabel = [_interfaceFactory makeTitleLabelWithText:@"Enter Your Name"];
    [arrangedSubviews addObject:titleLabel];

    // Description Label

    _descriptionLabel = [_interfaceFactory makeDescriptionLabelWithCompactFont:NO];
    [_descriptionLabel setText:@"We will use it to customize your feed. Press the Done key on your keyboard when you are finished."];
    [arrangedSubviews addObject:_descriptionLabel];

    // Text Field

    _textField = [UITextField new];
    [_textField setDelegate:self];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect];
    [_textField setReturnKeyType:UIReturnKeyDone];
    [arrangedSubviews addObject:_textField];
    
    return arrangedSubviews;

}

-(void)tearDown {
    [_textField setDelegate:NULL];
}

#pragma mark UITextFieldDelegate

-(BOOL)isInputValid:(NSString *)text {

    if (text == NULL || [text length] == 0) {
        return false;
    }

    return true;

};

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([self isInputValid: [textField text]]) {

        [_textField resignFirstResponder];

        if (self.actionHandler) {
            self.actionHandler(self);
        }

        return true;

    } else {

        UIColor *redColor = [[UIColor redColor] colorWithAlphaComponent:0.3];

        [_descriptionLabel setTextColor:[UIColor redColor]];
        [_descriptionLabel setText:@"You must enter some text to continue."];
        [_textField setBackgroundColor:redColor];

        return false;

    }

};

@end
