/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "TextFieldBulletinPage.h"

@implementation TextFieldBulletinPage {
    UILabel *_descriptionLabel;
    UITextField *_textField;
    HighlightButtonWrapper *_doneButton;
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
    [_descriptionLabel setText:@"To create your profile, please tell us your name. We will use it to customize your feed."];
    [arrangedSubviews addObject:_descriptionLabel];

    // Text Field

    _textField = [UITextField new];
    [_textField setDelegate:self];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect];
    [_textField setReturnKeyType:UIReturnKeyDone];
    [_textField setPlaceholder:@"First and Last Name"];
    [arrangedSubviews addObject:_textField];

    // Done Button

    _doneButton = [_interfaceFactory makeActionButtonWithTitle:@"Done"];
    [_doneButton.button addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [arrangedSubviews addObject:_doneButton];
    
    return arrangedSubviews;

}

-(void)tearDown {
    [_textField setDelegate:NULL];
    [_doneButton.button removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark UITextFieldDelegate

-(void)doneButtonTapped:(UIButton *)sender {
    [self textFieldShouldReturn:_textField];
};

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
