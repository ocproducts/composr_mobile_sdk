//
//  SignupViewController.m
//  CMS_SDK_Sample
//
//  Created by Aaswini on 08/03/16.
//  Copyright (c) 2016 Aaswini. All rights reserved.
//

#import "SignupViewController.h"
#import "CMS_Forms.h"
#import "CMSNetworkManager.h"

@interface SignupViewController () {
    CMS_Forms *form;
}

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createForm];
    [self setTitle:@"Signup"];
}

- (void)createForm{
    form = [[CMS_Forms alloc] initWithFrame:self.view.frame];
    [form setDelegate:self];
    [self.view addSubview:form];
    
    [form form_input_line_withPrettyName:@"Username" withDescription:@"Username" withParamName:@"username" withDefaultValue:@"" isRequired:YES];
    [form form_input_password_withPrettyName:@"Password" withDescription:@"Password" withParamName:@"password" withDefaultValue:@"" isRequired:YES];
    [form form_input_password_withPrettyName:@"Confirm Password" withDescription:@"Confirm Password" withParamName:@"password_confirm" withDefaultValue:@"" isRequired:YES];
    [form form_input_line_withPrettyName:@"Email" withDescription:@"Email" withParamName:@"email_address" withDefaultValue:@"" isRequired:YES];
    [form form_input_line_withPrettyName:@"Confirm Email" withDescription:@"Confirm Email" withParamName:@"email_address_confirm" withDefaultValue:@"" isRequired:YES];
    [form form_input_integer_withPrettyName:@"DOB day" withDescription:@"Day of Birth" withParamName:@"dob_day" withDefaultValue:@"" isRequired:YES];
    [form form_input_integer_withPrettyName:@"DOB month" withDescription:@"Month of Birth" withParamName:@"dob_month" withDefaultValue:@"" isRequired:YES];
    [form form_input_integer_withPrettyName:@"DOB year" withDescription:@"Year of Birth" withParamName:@"dob_year" withDefaultValue:@"" isRequired:YES];
    
    [form set_url:@"?hook_type=account&hook=join"];
    
    [form set_button_withName:@"Signup"
               preSubmitGuard:@selector(validationError)
                 postCallback:@selector(callback:)
                   autoSubmit:YES];
}

- (void)validationError {
    NSLog(@"Pre submitted callback");
}

- (void) callback:(id)response {
    if ([CMSNetworkManager isResponseValid:response]) {
        [[[UIAlertView alloc] initWithTitle:response[@"response_data"][@"message"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }
    else{
        NSError *error = [CMSNetworkManager getError:response];
        [[[UIAlertView alloc] initWithTitle:error.domain message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
