//
//  NumberInput.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 26/01/15.
//  Copyright (c) 2015 Aaswini. All rights reserved.
//

#import "NumberInput.h"

@implementation NumberInput

- (id)initWithFrame:(CGRect)frame defaultValue:(NSString *)defaultValue placeHolder:(NSString *)placeHolder supportFloat:(BOOL)supportFloat{
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultValue = defaultValue;
        self.placeHolder = placeHolder;
        self.supportFloat = supportFloat;
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    txtInput = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [txtInput setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [txtInput setPlaceholder:self.placeHolder];
    [txtInput setTag:111];
    [txtInput setDelegate:self];
    txtInput.borderStyle = UITextBorderStyleRoundedRect;
    txtInput.returnKeyType = UIReturnKeyDone;
    txtInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if (self.defaultValue != nil && ![self.defaultValue isEqualToString:@""]) {
        [txtInput setText:self.defaultValue];
        self.text = [txtInput text];
    }
    [self addSubview:txtInput];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
    
    if (textField == txtInput)
    {
        if (self.supportFloat) {
            
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                                options:0
                                                                  range:NSMakeRange(0, [newString length])];
            if (numberOfMatches == 0)
                return NO;
        }
        else {
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSString *expression = @"^([0-9]+)?(([0-9]{1,2})?)?$";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                                options:0
                                                                  range:NSMakeRange(0, [newString length])];
            if (numberOfMatches == 0)
                return NO;
        }
    }
    return YES;
}

@end
