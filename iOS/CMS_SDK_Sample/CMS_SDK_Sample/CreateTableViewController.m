//
//  CreateViewController.m
//  CMS_SDK_Sample
//
//  Created by Aaswini on 01/03/15.
//  Copyright (c) 2015 Aaswini. All rights reserved.
//

#import "CreateTableViewController.h"
#import "CMS_Forms.h"
#import "CMS_Database.h"
#import "CMS_Strings.h"

@interface CreateTableViewController () {
    CMS_Forms *form;
    int fieldCount;
}

@end

@implementation CreateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    fieldCount = 0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addField)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self setTitle:@"Create Table"];
    [self createForm];
}

- (void)createForm{
    CGRect frame = self.view.frame;
    frame.origin.y += self.navigationController.navigationBar.frame.size.height;
    frame.size.height -= self.navigationController.navigationBar.frame.size.height;
    form = [[CMS_Forms alloc] initWithFrame:frame];
    [form setDelegate:self];
    [self.view addSubview:form];
    
    [form form_input_field_spacer_withHeading:@"Table Name :" withText:self.tableName];
    
    [form set_button_withName:@"Done"
               preSubmitGuard:@selector(validationError)
                 postCallback:@selector(callback)
                   autoSubmit:NO];
}

- (void) addField {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Field Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView setDelegate:self];
    [alertView show];
}

- (void)validationError {
    [[[UIAlertView alloc] initWithTitle:@"Please donot leave the field names blank." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)callback {
    NSDictionary *tableFields = [form getFormValues];
    if (tableFields.count <= 0) {
        [[[UIAlertView alloc] initWithTitle:@"Please add fields to create a table." message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    [CMS_Database create_table:self.tableName :tableFields.allValues];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
        return;
    }
    
    fieldCount++;
    
    NSString *fieldName = [alertView textFieldAtIndex:0].text ;
    fieldName = [CMS_Strings trim:fieldName];
    fieldName = [CMS_Strings str_replace:@" " :@"_" :fieldName];
    
    [form form_input_line_withPrettyName:[NSString stringWithFormat:@"Table Field %d", fieldCount]
                         withDescription:[NSString stringWithFormat:@"Table Field %d", fieldCount]
                           withParamName:fieldName
                        withDefaultValue:fieldName isRequired:YES];
}

@end
