//
//  ComboBox.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 27/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComboBox : UIView<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>{
    UITextField *textField;
    UIPickerView* pickerView;
}

@property NSArray *options;
@property NSArray *keys;
@property NSString *text;
@property NSString *value;

- (void)setDefaultValue:(int)index;

@end
