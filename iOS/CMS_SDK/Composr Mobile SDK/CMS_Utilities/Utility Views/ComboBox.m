//
//  ComboBox.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 27/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "ComboBox.h"

@implementation ComboBox

@synthesize options;
@synthesize keys;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self initialize];
    }
    return self;
}

- (void) initialize{
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchDown];
    [textField setDelegate:self];
    [textField setText:@"select options"];
    [self setTag:111];
    [self addSubview:textField];
    self.value = nil;
    self.text = @"Select Option";
}

- (void)setDefaultValue:(int)index{
    if (index <= options.count && index >= 0) {
        textField.text = [options objectAtIndex:index];
        self.text = [textField text];
        self.value = [keys objectAtIndex:index];
    }
}

//-- UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    textField.text = [options objectAtIndex:row];
    self.text = [textField text];
    self.value = [keys objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [options count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [options objectAtIndex:row];
}

-(void)doneClicked:(id) sender
{
    int index = (int)[pickerView selectedRowInComponent:0];
    textField.text = [options objectAtIndex:index];
    self.text = [textField text];
    self.value = [keys objectAtIndex:index];
    
    [textField resignFirstResponder]; //hides the pickerView
}


- (IBAction)showPicker:(id)sender {
    
    pickerView == nil ? pickerView = [[UIPickerView alloc] init] : @"";
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    [self showPicker:aTextField];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

@end
