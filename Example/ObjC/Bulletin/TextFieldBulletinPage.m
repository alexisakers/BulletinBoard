/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

#import "TextFieldBulletinPage.h"

@implementation TextFieldBulletinPage {
    UILabel *_descriptionLabel;
    UITextField *_textField;
    HighlightButtonWrapper *_doneButton;
    BulletinAppearance *_appearance;
}

@synthesize nextItem;
@synthesize manager;
@synthesize isDismissable;
@synthesize dismissalHandler;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _appearance = [[BulletinAppearance alloc] init];
    }
    return self;
}

-(NSArray<UIView *> * _Nonnull)makeArrangedSubviews {

    NSMutableArray<UIView *> *arrangedSubviews = [NSMutableArray array];
    BulletinInterfaceBuilder *interfaceBuilder = [[BulletinInterfaceBuilder alloc] initWithAppearance:_appearance];

    // Title Label

    UILabel *titleLabel = [interfaceBuilder makeTitleLabelWithText:@"Enter Your Name"];
    [arrangedSubviews addObject:titleLabel];

    // Description Label

    NSString *description = @"To create your profile, please tell us your name. We will use it to customize your feed.";
    _descriptionLabel = [interfaceBuilder makeDescriptionLabelWithText:description];
    [arrangedSubviews addObject:_descriptionLabel];

    // Text Field

    _textField = [UITextField new];
    [_textField setDelegate:self];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect];
    [_textField setReturnKeyType:UIReturnKeyDone];
    [_textField setPlaceholder:@"First and Last Name"];
    [arrangedSubviews addObject:_textField];

    // Done Button

    _doneButton = [interfaceBuilder makeActionButtonWithTitle:@"Done"];
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
