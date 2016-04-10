//
//  AddTableRowViewController.m
//  CMS_SDK_Sample
//
//  Created by Aaswini on 01/03/15.
//  Copyright (c) 2015 Aaswini. All rights reserved.
//

#import "AddTableRowViewController.h"
#import "CMS_Forms.h"
#import "CMS_Database.h"

@interface AddTableRowViewController (){
    CMS_Forms *form;
}

@end

@implementation AddTableRowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createForm];
    
    [self setTitle:@"Create New Row"];
}

- (void)createForm{
    form = [[CMS_Forms alloc] initWithFrame:self.view.frame];
    [form setDelegate:self];
    [self.view addSubview:form];
    
    [form form_input_field_spacer_withHeading:@"Table Name :" withText:self.tableName];
    
    [form set_button_withName:@"Insert"
               preSubmitGuard:@selector(validationError)
                 postCallback:@selector(callback)
                   autoSubmit:NO];
    
    NSArray *fields = [CMS_Database getFieldNamesForTable:self.tableName];
    for (NSString *fieldName in fields) {
        [form form_input_line_withPrettyName:fieldName
                             withDescription:fieldName
                               withParamName:fieldName
                            withDefaultValue:@"" isRequired:YES];
    }
}

- (void)validationError {
    [[[UIAlertView alloc] initWithTitle:@"Please enter all fields." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)callback {
    NSDictionary *tableFields = [form getFormValues];
    [CMS_Database query_insert:self.tableName :tableFields];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
