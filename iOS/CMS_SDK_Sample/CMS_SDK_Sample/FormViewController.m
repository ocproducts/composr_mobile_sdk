//
//  FormViewController.m
//  CMS_SDK_Sample
//
//  Created by Aaswini on 01/03/15.
//  Copyright (c) 2015 Aaswini. All rights reserved.
//

#import "FormViewController.h"
#import "CMS_Forms.h"
#import "CMS_Flow.h"

@interface FormViewController (){
    CMS_Forms *form;
}

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createForm];
}

- (void)createForm{
    form = [[CMS_Forms alloc] initWithFrame:self.view.frame];
    [form setDelegate:self];
    [self.view addSubview:form];
    
    [form set_intro_text:@"My Form"];
    
    [form set_url:@"www.google.com"];
    
    [form set_button_withName:@"Done"
               preSubmitGuard:@selector(validationError)
                 postCallback:@selector(callback)
                   autoSubmit:YES];
    
    [form form_input_field_spacer_withHeading:@"Personal Details"
                                     withText:@"Please fill in your personal details"];
    
    [form form_input_uploaded_picture_withPrettyName:@"profilePic"
                                     withDescription:@"upload your profile pic"
                                       withParamName:@"profilePic"
                                          isRequired:YES];
    
    [form form_input_tick_withPrettyName:@"subscribe for newsletter ?"
                         withDescription:@""
                           withParamName:@"subscribe"
                        withDefaultValue:NO];
    
    [form form_input_list_withPrettyName:@"gender"
                         withDescription:@"Gender"
                           withParamName:@"gender"
                             withOptions:@{
                                           @"male":@"Male",
                                           @"female":@"Female"
                                           }
                        withDefaultValue:@"female"
                              isRequired:YES];
    
    [form form_input_date_withPrettyName:@"DOB"
                         withDescription:@"Provide your DOB :"
                           withParamName:@"dob"
                              isRequired:YES
                        withDefaultValue:@""
                       includeTimeChoice:NO];
    
    [form form_input_field_spacer_withHeading:@"Education Details"
                                     withText:@"Please fill the details below"];
    
    [form form_input_float_withPrettyName:@"Degree Percentage"
                          withDescription:@"Degree Percentage"
                            withParamName:@"degree_percent"
                         withDefaultValue:@"0"
                               isRequired:YES];
    
    [form form_input_integer_withPrettyName:@"Degree Completed Year"
                            withDescription:@"Degree Completed Year"
                              withParamName:@"degree_year"
                           withDefaultValue:@""
                                 isRequired:NO];
    
    [form form_input_hidden_withParamName:@"ios" withParamValue:@"1"];
    
    [form form_input_line_withPrettyName:@"Expertize"
                         withDescription:@"Provide your expertize."
                           withParamName:@"expertize"
                        withDefaultValue:@"ios, android" isRequired:NO];
    
    [form form_input_text_withPrettyName:@"some field"
                         withDescription:@"some field"
                           withParamName:@"some field"
                        withDefaultValue:@""
                              isRequired:YES];
}

- (void)validationError{
    [CMS_Flow warn_screen:@"Please enter all fields." :self];
}

- (void)callback{
    [CMS_Flow attach_message:@"Submitted form"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
