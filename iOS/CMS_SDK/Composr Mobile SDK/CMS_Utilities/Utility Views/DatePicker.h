//
//  DatePicker.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 01/09/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePicker : UIView<UITextFieldDelegate>{
    UITextField *textField;
    UIDatePicker* pickerView;
    BOOL isTimeRequired;
}

@property NSString *text;
@property int timestamp;

- (id)initDatePickerWithTime:(BOOL)shouldShowTime frame:(CGRect)frame;



@end
