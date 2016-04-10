//
//  DatePicker.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 01/09/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "DatePicker.h"

@implementation DatePicker{
    NSDateFormatter *dateFormatter;
}

- (id)initDatePickerWithTime:(BOOL)shouldShowTime frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        isTimeRequired = shouldShowTime;
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

- (void) initialize{
    
    if (isTimeRequired) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd hh:mm:ss" options:0 locale:[NSLocale systemLocale]];
    }
    else{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:[NSLocale systemLocale]];
    }
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchDown];
    [textField setDelegate:self];
    [textField setText:@"Select Date"];
    [textField setTag:111];
    [self addSubview:textField];
    self.timestamp = 0;
}

- (IBAction)showPicker:(id)sender {
    
    pickerView == nil ? pickerView = [[UIDatePicker alloc] init] : @"";
    if (isTimeRequired) {
        [pickerView setDatePickerMode:UIDatePickerModeDateAndTime];
    }
    else{
        [pickerView setDatePickerMode:UIDatePickerModeDate];
    }
    [pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    //custom input view
    textField.inputView = pickerView;
    textField.inputAccessoryView = toolbar;
}

-(void)doneClicked:(id) sender
{
    textField.text = [dateFormatter stringFromDate:pickerView.date];
    self.text = [textField text];
    self.timestamp = [pickerView.date timeIntervalSince1970];
    [textField resignFirstResponder]; //hides the pickerView
}

- (IBAction)dateChanged:(id)sender {
    textField.text = [dateFormatter stringFromDate:pickerView.date];
    self.text = [textField text];
    self.timestamp = [pickerView.date timeIntervalSince1970];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    [self showPicker:aTextField];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

@end
