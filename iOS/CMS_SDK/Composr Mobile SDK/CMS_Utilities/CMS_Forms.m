//
//  CMS_Forms.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*
 Form field dictionary prototype
 
 @{
 @"field_Type" : @"<field type from fieldType enum>",
 @"field_Name" : @"pretty name for the field",
 @"field_Description" : @"description for the field",
 @"field_Param_Name" : @"form field parameter name",
 @"field_Values" : @"values that needs to be preloaded - like options for list",
 @"field_Default_Value" : @"default value for field",
 @"field_is_Mandatory" : @"field is mandatory or not",
 @"field_Extra_Params" : @"A dictionary for storing any extra values",
 @"field_Object" : @"an object that represents the object and any subobjects if required"
 }
 */

#import "CMS_Forms.h"
#import "CMS_Arrays.h"
#import "ComboBox.h"
#import "PhotoUpload.h"
#import "DatePicker.h"
#import "NumberInput.h"
#import "CMSNetworkManager.h"

int formY = 0;

#define formWidth [self frame].size.width
#define formFieldHeight 70.0
#define formRect CGRectMake(0, formY, formWidth, formFieldHeight)
#define formFieldViewTag 111

#define kOFFSET_FOR_KEYBOARD 80.0

@implementation CMS_Forms{
    NSMutableArray *formFields; //contains all form elements
    NSString *introText;
    NSString *targetUrl;
    NSString *submitBtnName;
    SEL submitCallback;
    SEL preSubmitCallback;
    CGRect backupFrame;
}

UIView *form;
UIScrollView *formContainer;
UIView *submitContainer;
UIView *introContainer;

UIButton *submitBtn;
UILabel *introLbl;

@synthesize delegate;

- (id) init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize{
    formY = 0;
    formFields = [NSMutableArray new];
    introText = @"Form";
    targetUrl = @"";
    submitBtnName = @"Submit";
    
    //creating submit button and it's container view
    {
        submitContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 70, self.frame.size.width, 70)];
        
        submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [submitBtn setTitle:submitBtnName forState:UIControlStateNormal];
        [submitBtn setFrame:CGRectMake(10, 10, submitContainer.frame.size.width-20, submitContainer.frame.size.height -20)];
        
        [submitContainer addSubview:submitBtn];
        [self addSubview:submitContainer];
    }
    
    //creating introText containter
    {
        introContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 70)];
        
        introLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, introContainer.frame.size.width-20, introContainer.frame.size.height-20)];
        [introLbl setTextAlignment:NSTextAlignmentCenter];
        [introLbl setText:introText];
        
        [introContainer addSubview:introLbl];
    }
    
    //creating scrollview and form superview
    {
        formContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, introContainer.frame.size.height, self.frame.size.width, self.frame.size.height - submitContainer.frame.size.height - introContainer.frame.size.height)];
        [formContainer setClipsToBounds:YES];
        
        form = [[UIView alloc] initWithFrame:CGRectMake(0, 0, formContainer.frame.size.width, 0)];
        
        [formContainer setContentSize:form.frame.size];
        [formContainer addSubview:form];
    }
    
    [self addSubview:introContainer];
    [self addSubview:formContainer];
    [self addSubview:submitContainer];
    
    //adding observer for keyboard popup
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [self addGestureRecognizer:tap];
}

- (void)singleTap {
    [self endEditing:YES];
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)form_input_field_spacer_withHeading:(NSString *)heading withText:(NSString *)text{
    UIView *fieldView = [UIView new];
    [fieldView setFrame:formRect];
    
    UILabel *lblHeading = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fieldView.frame.size.width - 10, 30)];
    [lblHeading setText:heading];
    
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, fieldView.frame.size.width - 10, 30)];
    [lblText setText:text];
    
    [fieldView addSubview:lblHeading];
    [fieldView addSubview:lblText];
    
    NSDictionary *field = @{
                            @"field_Type" : [NSString stringWithFormat:@"%d",Input_Field_Spacer],
                            @"field_Name" : heading,
                            @"field_Description" : text,
                            @"field_Param_Name" : @"form field parameter name",
                            @"field_Values" : @"values that needs to be preloaded - like options for list",
                            @"field_Default_Value" : @"default value for field",
                            @"field_is_Mandatory" : @"field is mandatory or not",
                            @"field_Extra_Params" : @"A dictionary for storing any extra values",
                            @"field_Object" : fieldView
                            };
    
    [formFields addObject:field];
    [form addSubview:fieldView];
    formY += 90;
    [self addFormHeight:90];
    
}

- (void)form_input_hidden_withParamName:(NSString *)paramName withParamValue:(NSString *)paramValue{
    NSDictionary *field = @{
                            @"field_Type" : [NSString stringWithFormat:@"%d",Input_Field_Hidden],
                            @"field_Name" : @"pretty name for the field",
                            @"field_Description" : @"description for the field",
                            @"field_Param_Name" : paramName,
                            @"field_Values" : paramValue,
                            @"field_Default_Value" : @"default value for field",
                            @"field_is_Mandatory" : @"field is mandatory or not",
                            @"field_Extra_Params" : @"A dictionary for storing any extra values",
                            @"field_Object" : @"an object that represents the object and any subobjects if required"
                            };
    
    [formFields addObject:field];
}

- (id)form_input_integer_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired{
    
    UIView *fieldView = [UIView new];
    [fieldView setFrame:formRect];
    
    UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fieldView.frame.size.width - 10, 30)];
    [lblDescription setText:description];
    
    NumberInput *txtInput = [[NumberInput alloc] initWithFrame:CGRectMake(10, 35, fieldView.frame.size.width - 20, 30) defaultValue:defaultValue placeHolder:prettyName supportFloat:NO];
    [txtInput setTag:113];
    
    [fieldView addSubview:lblDescription];
    [fieldView addSubview:txtInput];
    
    NSDictionary *field = @{
                            @"field_Type" : [NSString stringWithFormat:@"%d",Input_Field_Integer],
                            @"field_Name" : prettyName,
                            @"field_Description" : description,
                            @"field_Param_Name" : paramName,
                            @"field_Values" : @"values that needs to be preloaded - like options for list",
                            @"field_Default_Value" : defaultValue,
                            @"field_is_Mandatory" : isRequired ? @"1" : @"0",
                            @"field_Extra_Params" : @"A dictionary for storing any extra values",
                            @"field_Object" : fieldView
                            };
    
    [formFields addObject:field];
    [form addSubview:fieldView];
    formY += 90;
    [self addFormHeight:90];
    
    return fieldView;
}

- (id)form_input_float_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired{
    
    UIView *fieldView = [UIView new];
    [fieldView setFrame:formRect];
    
    UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fieldView.frame.size.width - 10, 30)];
    [lblDescription setText:description];
    
    NumberInput *txtInput = [[NumberInput alloc] initWithFrame:CGRectMake(10, 35, fieldView.frame.size.width - 20, 30) defaultValue:defaultValue placeHolder:prettyName supportFloat:YES];
    [txtInput setTag:114];
    
    [fieldView addSubview:lblDescription];
    [fieldView addSubview:txtInput];
    
    NSDictionary *field = @{
                            @"field_Type" : [NSString stringWithFormat:@"%d",Input_Field_Float],
                            @"field_Name" : prettyName,
                            @"field_Description" : description,
                            @"field_Param_Name" : paramName,
                            @"field_Values" : @"values that needs to be preloaded - like options for list",
                            @"field_Default_Value" : defaultValue,
                            @"field_is_Mandatory" : isRequired ? @"1" : @"0",
                            @"field_Extra_Params" : @"A dictionary for storing any extra values",
                            @"field_Object" : fieldView
                            };
    
    [formFields addObject:field];
    [form addSubview:fieldView];
    formY += 90;
    [self addFormHeight:90];
    
    return fieldView;
}

- (id)form_input_line_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired{
    
    UIView *fieldView = [UIView new];
    [fieldView setFrame:formRect];
    
    UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fieldView.frame.size.width - 10, 30)];
    [lblDescription setText:description];
    
    UITextField *txtInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 35, fieldView.frame.size.width - 20, 30)];
    [txtInput setKeyboardType:UIKeyboardTypeDefault];
    [txtInput setPlaceholder:prettyName];
    [txtInput setTag:formFieldViewTag];
    [txtInput setDelegate:self];
    txtInput.borderStyle = UITextBorderStyleRoundedRect;
    txtInput.returnKeyType = UIReturnKeyDone;
    txtInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if (defaultValue != nil && ![defaultValue isEqualToString:@""]) {
        [txtInput setText:defaultValue];
    }
    
    [fieldView addSubview:lblDescription];
    [fieldView addSubview:txtInput];
    
    NSDictionary *field = @{
                            @"field_Type" : [NSString stringWithFormat:@"%d",Input_Field_Line],
                            @"field_Name" : prettyName,
                            @"field_Description" : description,
                            @"field_Param_Name" : paramName,
                            @"field_Values" : @"values that needs to be preloaded - like options for list",
                            @"field_Default_Value" : defaultValue,
                            @"field_is_Mandatory" : isRequired ? @"1" : @"0",
                            @"field_Extra_Params" : @"A dictionary for storing any extra values",
                            @"field_Object" : fieldView
                            };
    
    [formFields addObject:field];
    [form addSubview:fieldView];
    formY += 90;
    [self addFormHeight:90];
    
    return fieldView;
}

- (id)form_input_password_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired{
    
    UIView *fieldView = [UIView new];
    [fieldView setFrame:formRect];
    
    UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fieldView.frame.size.width - 10, 30)];
    [lblDescription setText:description];
    
    UITextField *txtInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 35, fieldView.frame.size.width - 20, 30)];
    [txtInput setKeyboardType:UIKeyboardTypeDefault];
    [txtInput setPlaceholder:prettyName];
    [txtInput setTag:formFieldViewTag];
    [txtInput setDelegate:self];
    [txtInput setSecureTextEntry:YES];
    txtInput.borderStyle = UITextBorderStyleRoundedRect;
    txtInput.returnKeyType = UIReturnKeyDone;
    txtInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if (defaultValue != nil && ![defaultValue isEqualToString:@""]) {
        [txtInput setText:defaultValue];
    }
    
    [fieldView addSubview:lblDescription];
    [fieldView addSubview:txtInput];
    
    NSDictionary *field = @{
                            @"field_Type" : [NSString stringWithFormat:@"%d",Input_Field_Line],
                            @"field_Name" : prettyName,
                            @"field_Description" : description,
                            @"field_Param_Name" : paramName,
                            @"field_Values" : @"values that needs to be preloaded - like options for list",
                            @"field_Default_Value" : defaultValue,
                            @"field_is_Mandatory" : isRequired ? @"1" : @"0",
                            @"field_Extra_Params" : @"A dictionary for storing any extra values",
                            @"field_Object" : fieldView
                            };
    
    [formFields addObject:field];
    [form addSubview:fieldView];
    formY += 90;
    [self addFormHeight:90];
    
    return fieldView;
}

- (id)form_input_list_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withOptions:(NSDictionary *)options withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired{
    
    UIView *fieldView = [UIView new];
    [fieldView setFrame:formRect];
    
    UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fieldView.frame.size.width - 10, 30)];
    [lblDescription setText:description];
    
    ComboBox *txtInput = [[ComboBox alloc] initWithFrame:CGRectMake(10, 35, fieldView.frame.size.width - 20, 30)];
    [txtInput setOptions:[options allValues]];
    [txtInput setKeys:[options allKeys]];
    
    int valueIndex = 0;
    for (NSString *option in options.allKeys) {
        if ([option isEqualToString:defaultValue]) {
            valueIndex = (int)[options.allKeys indexOfObject:option];
            break;
        }
    }
    
    [txtInput setDefaultValue:valueIndex];
    
    [fieldView addSubview:lblDescription];
    [fieldView addSubview:txtInput];
    
    NSDictionary *field = @{
                            @"field_Type" : [NSString stringWithFormat:@"%d",Input_Field_List],
                            @"field_Name" : prettyName,
                            @"field_Description" : description,
                            @"field_Param_Name" : paramName,
                            @"field_Values" : @"values that needs to be preloaded - like options for list",
                            @"field_Default_Value" : [NSString stringWithFormat:@"%d",valueIndex],
                            @"field_is_Mandatory" : isRequired ? @"1" : @"0",
                            @"field_Extra_Params" : @"A dictionary for storing any extra values",
                            @"field_Object" : fieldView
                            };
    
    [formFields addObject:field];
    [form addSubview:fieldView];
    formY += 90;
    [self addFormHeight:90];
    
    return fieldView;
}

- (id)form_input_text_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired{
    
    UIView *fieldView = [UIView new];
    CGRect textFieldRect = formRect;
    textFieldRect.size.height += 60;
    [fieldView setFrame:textFieldRect];
    
    UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fieldView.frame.size.width - 10, 30)];
    [lblDescription setText:description];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 35, fieldView.frame.size.width - 20, 90)];
    textView.backgroundColor = [UIColor clearColor];
    [textView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [textView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [textView.layer setBorderWidth:1.0];
    textView.layer.cornerRadius = 5;
    textView.clipsToBounds = YES;
    textView.scrollEnabled = YES;
    textView.editable = YES;
    [textView setTag:formFieldViewTag];
    if (defaultValue != nil && ![defaultValue isEqualToString:@""]) {
        [textView setText:defaultValue];
    }
    
    [fieldView addSubview:lblDescription];
    [fieldView addSubview:textView];
    
    NSDictionary *field = @{
                            @"field_Type" : [NSString stringWithFormat:@"%d",Input_Field_Text],
                            @"field_Name" : prettyName,
                            @"field_Description" : description,
                            @"field_Param_Name" : paramName,
                            @"field_Values" : @"values that needs to be preloaded - like options for list",
                            @"field_Default_Value" : defaultValue,
                            @"field_is_Mandatory" : isRequired ? @"1" : @"0",
                            @"field_Extra_Params" : @"A dictionary for storing any extra values",
                            @"field_Object" : fieldView
                            };
    
    [formFields addObject:field];
    [form addSubview:fieldView];
    formY += 150;
    [self addFormHeight:150];
    
    return fieldView;
}

- (id)form_input_tick_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(BOOL)defaultValue{
    
    UIView *fieldView = [UIView new];
    [fieldView setFrame:formRect];
    
    UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fieldView.frame.size.width - 10, 30)];
    [lblDescription setText:description];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, fieldView.frame.size.width - 70, 31)];
    [name setText:prettyName];
    
    UISwitch *txtInput = [[UISwitch alloc] initWithFrame:CGRectMake(name.frame.origin.x + name.frame.size.width + 5, 35, 51, 31)];
    [txtInput setOn:defaultValue];
    [txtInput setTag:formFieldViewTag];
    
    [fieldView addSubview:lblDescription];
    [fieldView addSubview:name];
    [fieldView addSubview:txtInput];
    
    NSDictionary *field = @{
                            @"field_Type" : [NSString stringWithFormat:@"%d",Input_Field_Tick],
                            @"field_Name" : prettyName,
                            @"field_Description" : description,
                            @"field_Param_Name" : paramName,
                            @"field_Values" : @"values that needs to be preloaded - like options for list",
                            @"field_Default_Value" : [NSNumber numberWithBool:defaultValue],
                            @"field_is_Mandatory" : @"field is mandatory or not",
                            @"field_Extra_Params" : @"A dictionary for storing any extra values",
                            @"field_Object" : fieldView
                            };
    
    [formFields addObject:field];
    [form addSubview:fieldView];
    formY += 90;
    [self addFormHeight:90];
    
    return fieldView;
}

- (id)form_input_uploaded_picture_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName isRequired:(BOOL)isRequired{
    UIView *fieldView = [UIView new];
    [fieldView setFrame:CGRectMake(0, formY, formWidth, formFieldHeight + 70)];
    
    UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fieldView.frame.size.width - 10, 30)];
    [lblDescription setText:description];
    
    PhotoUpload *photoView = [[PhotoUpload alloc] initWithFrame:CGRectMake(10, 35, 100, 100)];
    [photoView setImage:[UIImage imageNamed:@"no_image.png"]];
    [photoView setTag:formFieldViewTag];
    
    [fieldView addSubview:lblDescription];
    [fieldView addSubview:photoView];
    
    NSDictionary *field = @{
                            @"field_Type" : [NSString stringWithFormat:@"%d",Input_Field_Upload_Picture],
                            @"field_Name" : prettyName,
                            @"field_Description" : description,
                            @"field_Param_Name" : paramName,
                            @"field_Values" : @"values that needs to be preloaded - like options for list",
                            @"field_Default_Value" : @"default value for field",
                            @"field_is_Mandatory" : isRequired ? @"1" : @"0",
                            @"field_Extra_Params" : @"A dictionary for storing any extra values",
                            @"field_Object" : fieldView
                            };
    
    [formFields addObject:field];
    [form addSubview:fieldView];
    formY += (90+70);
    [self addFormHeight:90+70];
    
    return fieldView;
}

- (id)form_input_date_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName isRequired:(BOOL)isRequired withDefaultValue:(NSString *)defaultValue includeTimeChoice:(BOOL)includeTimeChoice{
    
    UIView *fieldView = [UIView new];
    [fieldView setFrame:formRect];
    
    UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fieldView.frame.size.width - 10, 30)];
    [lblDescription setText:description];
    
    DatePicker *txtInput = [[DatePicker alloc] initDatePickerWithTime:includeTimeChoice frame:CGRectMake(10, 35, fieldView.frame.size.width - 20, 30)];
    [txtInput setTag:112];
    
    [fieldView addSubview:lblDescription];
    [fieldView addSubview:txtInput];
    
    NSDictionary *field = @{
                            @"field_Type" : [NSString stringWithFormat:@"%d",Input_Field_Date],
                            @"field_Name" : prettyName,
                            @"field_Description" : description,
                            @"field_Param_Name" : paramName,
                            @"field_Values" : @"values that needs to be preloaded - like options for list",
                            @"field_Default_Value" : defaultValue,
                            @"field_is_Mandatory" : isRequired ? @"1" : @"0",
                            @"field_Extra_Params" : @"A dictionary for storing any extra values",
                            @"field_Object" : fieldView
                            };
    
    [formFields addObject:field];
    [form addSubview:fieldView];
    formY += 90;
    [self addFormHeight:90];
    
    return fieldView;
}

- (int)get_input_date:(NSString *)paramName{
    
    return [(NSNumber *)[self get_form_field_value:[self getFormFieldDict:paramName]] intValue];
}

- (NSString *)post_param_string:(NSString *)paramName{
    
    return [NSString stringWithFormat:@"%@",[self get_form_field_value:[self getFormFieldDict:paramName]]];
}

- (int)post_param_integer:(NSString *)paramName{
    
    return [(NSString *)[self get_form_field_value:[self getFormFieldDict:paramName]] intValue];
}

- (void)set_intro_text:(NSString *)text{
    introText = [NSString stringWithString:text];
    [introLbl setText:introText];
}

- (void)set_url:(NSString *)url{
    targetUrl = [NSString stringWithString:url];
}

- (void)set_button_withName:(NSString *)name preSubmitGuard:(SEL)preSubmitGuard postCallback:(SEL)postCallback autoSubmit:(BOOL)autoSubmit{
    submitBtnName = [NSString stringWithString:name];
    [submitBtn setTitle:submitBtnName forState:UIControlStateNormal];
    if (autoSubmit) {
        [submitBtn addTarget:self action:@selector(do_http_post_request:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [submitBtn addTarget:self action:@selector(doValidateForm) forControlEvents:UIControlEventTouchUpInside];
    }
    
    preSubmitCallback = preSubmitGuard;
    submitCallback = postCallback;
}

- (void) doValidateForm {
    if (![self validateForm]) {
        if (delegate != nil && preSubmitCallback!=nil) {
            if ([delegate respondsToSelector:preSubmitCallback]) {
                [delegate performSelector:preSubmitCallback];
            }
        }
        return;
    }
    else {
        if (delegate!=nil && [delegate respondsToSelector:submitCallback]) {
            [delegate performSelector:submitCallback];
        }
    }
}

- (NSDictionary *)getFormValues{
    NSArray *fieldTypes = [CMS_Arrays collapse_1d_complexity:@"field_Type" :formFields];
    NSArray *paramNames = [CMS_Arrays collapse_1d_complexity:@"field_Param_Name" :formFields];
    
    NSMutableDictionary *postParams = [NSMutableDictionary new];
    for (int i=0; i<formFields.count; i++) {
        if ([fieldTypes[i] intValue] == Input_Field_Spacer) {
            continue ;
        }
        if ([fieldTypes[i] intValue] != Input_Field_Upload_Picture) {
            [postParams setObject:[self get_form_field_value:formFields[i]] forKey:paramNames[i]];
        }
    }
    return postParams;
}

- (void)do_http_post_request:(SEL)callback{
    
    if (![self validateForm]) {
        if (delegate != nil && preSubmitCallback!=nil) {
            if ([delegate respondsToSelector:preSubmitCallback]) {
                [delegate performSelector:preSubmitCallback];
            }
        }
        return;
    }
    
    NSArray *fieldTypes = [CMS_Arrays collapse_1d_complexity:@"field_Type" :formFields];
    NSArray *paramNames = [CMS_Arrays collapse_1d_complexity:@"field_Param_Name" :formFields];
    
    NSMutableArray *multiPartDataParams = [NSMutableArray new];
    for (int i=0; i<fieldTypes.count; i++) {
        if ([fieldTypes[i] intValue] == Input_Field_Upload_Picture) {
            [multiPartDataParams addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    NSMutableDictionary *postParams = [NSMutableDictionary new];
    for (int i=0; i<formFields.count; i++) {
        if ([fieldTypes[i] intValue] == Input_Field_Spacer) {
            continue ;
        }
        if ([fieldTypes[i] intValue] != Input_Field_Upload_Picture) {
            [postParams setObject:[self get_form_field_value:formFields[i]] forKey:paramNames[i]];
        }
    }
    
    [MBProgressHUD showGlobalProgressHUD];
    CMSNetworkManager *networkManager = [CMSNetworkManager sharedManager];
    [networkManager POST:targetUrl
              parameters:postParams
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    for (NSString *i in multiPartDataParams) {
        int index = [i intValue];
        [formData appendPartWithFormData:(NSData *)[self get_form_field_value:formFields[index]] name:paramNames[index]];
    }
}
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"%@",responseObject);
                     if (delegate != nil) {
                         if ([delegate respondsToSelector:submitCallback]) {
                             [delegate performSelector:submitCallback withObject:responseObject];
                         }
                         if (callback && [delegate respondsToSelector:callback]) {
                             [delegate performSelector:callback];
                         }
                     }
                     [MBProgressHUD dismissGlobalHUD];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"%@",error.localizedDescription);
                     [MBProgressHUD dismissGlobalHUD];
                 }
     ];
    
}

- (NSObject *) get_form_field_value:(NSDictionary *)formField{
    int fieldType = [[formField valueForKey:@"field_Type"] intValue];
    
    NSObject *value;
    
    if (fieldType == Input_Field_Hidden) {
        value = [formField objectForKey:@"field_Values"];
    }
    else if (fieldType == Input_Field_Upload_Picture){
        value = UIImageJPEGRepresentation([(UIImageView *)[(UIView *)[formField objectForKey:@"field_Object"] viewWithTag:formFieldViewTag] image],0.6);
    }
    else if (fieldType == Input_Field_Date){
        value = [NSString stringWithFormat:@"%d",[(DatePicker *)[(UIView *)[formField objectForKey:@"field_Object"] viewWithTag:112] timestamp]];
    }
    else if (fieldType == Input_Field_Tick){
        value = [(UISwitch *)[(UIView *)[formField objectForKey:@"field_Object"] viewWithTag:formFieldViewTag] isOn] ? @"YES" :@"NO";
    }
    else if (fieldType == Input_Field_List){
        value = [(ComboBox *)[(UIView *)[formField objectForKey:@"field_Object"] viewWithTag:formFieldViewTag] value];
    }
    else{
        value = [(UITextField *)[(UIView *)[formField objectForKey:@"field_Object"] viewWithTag:formFieldViewTag] text];
    }
    
    return value;
}

- (NSDictionary *)getFormFieldDict:(NSString *)paramName{
    for (NSDictionary *dict in formFields) {
        if ([[dict objectForKey:@"field_Param_Name"] isEqualToString:paramName]) {
            return dict;
        }
    }
    return nil;
}

- (BOOL) validateForm{
    
    BOOL pass = YES;
    
    for (NSDictionary *formField in formFields) {
        
        if ([[formField objectForKey:@"field_is_Mandatory"]intValue] == 0) {
            continue;
        }
        
        switch ([[formField objectForKey:@"field_Type"] intValue]) {
            case Input_Field_Float:
            case Input_Field_Integer:
            case Input_Field_Line:
            case Input_Field_Text:
            case Input_Field_List:
            {
                NSString *value = (NSString *)[self get_form_field_value:formField];
                if (value==nil || [value isEqualToString:@""]) {
                    UIView *formFieldView = [formField objectForKey:@"field_Object"];
                    [formFieldView setBackgroundColor:[UIColor redColor]];
                    [formFieldView setAlpha:0.3];
                    
                    pass = NO;
                }
                else{
                    UIView *formFieldView = [formField objectForKey:@"field_Object"];
                    [formFieldView setBackgroundColor:[UIColor clearColor]];
                    [formFieldView setAlpha:1];
                }
                
                break;
            }
            case Input_Field_Upload_Picture:
                
                break;
                
            case Input_Field_Date:
            {
                NSString *value = (NSString *)[self get_form_field_value:formField];
                if (value==nil || [value isEqualToString:@"0"]) {
                    UIView *formFieldView = [formField objectForKey:@"field_Object"];
                    [formFieldView setBackgroundColor:[UIColor redColor]];
                    [formFieldView setAlpha:0.3];
                    
                    pass = NO;
                }
                else{
                    UIView *formFieldView = [formField objectForKey:@"field_Object"];
                    [formFieldView setBackgroundColor:[UIColor clearColor]];
                    [formFieldView setAlpha:1];
                }
                
                break;
            }
                
            default:
                break;
        }
    }
    
    return pass;
}

- (void) addFormHeight:(float)height{
    CGRect currentFrame = [form frame];
    [form setFrame:CGRectMake(currentFrame.origin.x, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height + height)];
    [formContainer setContentSize:form.frame.size];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark View anmations and listeners for keyboard show and hide
-(void)setViewMovedUp:(BOOL)movedUp
{
    // ios9 method gets entered when the view is attached
    if (!movedUp && backupFrame.size.height == 0 && backupFrame.size.width == 0) {
        return;
    }
    
    // backup original frame instead of referring origin with keyboard frame
    if (movedUp) {
        backupFrame = self.frame;
    }
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.frame;
    
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
        [self setBackgroundColor:[UIColor yellowColor]];
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y = backupFrame.origin.y;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
        [self setBackgroundColor:[UIColor redColor]];
    }
    self.frame = rect;
    
    [UIView commitAnimations];
}

- (void)keyboardDidShow
{
    [self setViewMovedUp:YES];
}

-(void)keyboardDidHide
{
    [self setViewMovedUp:NO];
}

#pragma mark -------

@end
