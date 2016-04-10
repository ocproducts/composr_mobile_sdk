//
//  ContactViewController.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 07/11/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMSContactViewController.h"
#import "CMS_Langs.h"

#define LABEL_CONTACT_SUBJECT   @"LABEL_CONTACT_SUBJECT"
#define LABEL_CONTACT_EMAIL     @"LABEL_CONTACT_EMAIL"
#define LABEL_CONTACT_MESSAGE   @"LABEL_CONTACT_MESSAGE"
#define BUTTON_CONTACT_SAVE     @"BUTTON_CONTACT_SAVE"

@implementation CMSContactViewController

@synthesize txtSubject,txtMessage,txtEmail;

- (id) init{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:CMS_STORYBOARD_NAME bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:STORYBOARD_ID_CMSContactViewController];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.lblSubject setText:[CMS_Langs do_lang:LABEL_CONTACT_SUBJECT]];
    [self.lblEmail setText:[CMS_Langs do_lang:LABEL_CONTACT_EMAIL]];
    [self.lblMessage setText:[CMS_Langs do_lang:LABEL_CONTACT_MESSAGE]];
    [self.btnSave setTitle:[CMS_Langs do_lang:BUTTON_CONTACT_SAVE] forState:UIControlStateNormal];
    
    txtMessage.layer.cornerRadius = 5;
    [txtMessage.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    
    [txtMessage.layer setBorderWidth:2.0];
    txtMessage.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSave:(id)sender {
    
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    
    [[CMSNetworkManager sharedManager] setFeedbackDelegate:self];
    [[CMSNetworkManager sharedManager] feedbackWithTitle:txtSubject.text email:txtEmail.text post:txtMessage.text onCompletion:nil onFaillure:nil showLoader:YES];
}

- (NSString *)validateForm
{
    NSString *errorMessage;
    
    NSString *regex = @"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (!(self.txtSubject.text.length >= 1)){
        errorMessage = @"Please enter a Subject";
    } else if (![emailPredicate evaluateWithObject:self.txtEmail.text]){
        errorMessage = @"Please enter a valid email address";
    } else if (!(self.txtMessage.text.length >= 1)){
        errorMessage = @"Please enter a message";
    }
    
    return errorMessage;
}

#pragma mark - TextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtSubject) {
        [self.txtEmail becomeFirstResponder];
    } else if (textField == self.txtEmail) {
        [self.txtMessage becomeFirstResponder];
    }
    return YES;
}

#pragma mark - CMSNetworkManager_RecoverPasswordDelegate methods

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didFeedbackWithResponse:(NSDictionary *)response
{
    NSLog(@"Feedback Request Successful");
    NSLog(@"%@",response);
    [[[UIAlertView alloc] initWithTitle:response[@"response_data"][@"message"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didFailToFeedbackWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:nil message:@"Feedback Request failed" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    NSLog(@"%@", error.description);
}


@end
