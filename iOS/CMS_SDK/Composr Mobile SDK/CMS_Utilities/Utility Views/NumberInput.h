//
//  NumberInput.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 26/01/15.
//  Copyright (c) 2015 Aaswini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberInput : UIView<UITextFieldDelegate>{
    UITextField *txtInput;
}

@property NSString *text;
@property NSString *defaultValue;
@property NSString *placeHolder;
@property BOOL supportFloat;

- (id)initWithFrame:(CGRect)frame defaultValue:(NSString *)defaultValue placeHolder:(NSString *)placeHolder supportFloat:(BOOL)supportFloat;

@end
