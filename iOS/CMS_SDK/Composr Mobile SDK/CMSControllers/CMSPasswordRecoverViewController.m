//
//  PasswordRecoverViewController.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 17/10/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMSPasswordRecoverViewController.h"
#import "CMS_Langs.h"

#define LABEL_PASSWORD_RECOVER_FORGOT_PASSWORD @"LABEL_PASSWORD_RECOVER_FORGOT_PASSWORD"
#define LABEL_PASSWORD_RECOVER_EMAIL           @"LABEL_PASSWORD_RECOVER_EMAIL"
#define BUTTON_PASSWORD_RECOVER_SUBMIT         @"BUTTON_PASSWORD_RECOVER_SUBMIT"
#define BUTTON_PASSWORD_RECOVER_CANCEL         @"BUTTON_PASSWORD_RECOVER_CANCEL"

@implementation CMSPasswordRecoverViewController

@synthesize txtEmail;

- (id) init{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:CMS_STORYBOARD_NAME bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:STORYBOARD_ID_CMSPasswordRecoverViewController];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.lblForgotPassword setText:[CMS_Langs do_lang:LABEL_PASSWORD_RECOVER_FORGOT_PASSWORD]];
    [self.lblUsername setText:[CMS_Langs do_lang:LABEL_PASSWORD_RECOVER_EMAIL]];
    [self.btnSubmit setTitle:[CMS_Langs do_lang:BUTTON_PASSWORD_RECOVER_SUBMIT] forState:UIControlStateNormal];
    [self.btnCancel setTitle:[CMS_Langs do_lang:BUTTON_PASSWORD_RECOVER_CANCEL] forState:UIControlStateNormal];
    
    [self setTitle:@"Reset Password"];
}

-(BOOL)isPresentedAsModal {
    
    BOOL isModal = ((self.parentViewController && self.parentViewController.modalViewController == self) ||
                    //or if I have a navigation controller, check if its parent modal view controller is self navigation controller
                    ( self.navigationController && self.navigationController.parentViewController && self.navigationController.parentViewController.modalViewController == self.navigationController) ||
                    //or if the parent of my UITabBarController is also a UITabBarController class, then there is no way to do that, except by using a modal presentation
                    [[[self tabBarController] parentViewController] isKindOfClass:[UITabBarController class]]);
    
    //iOS 5+
    if (!isModal && [self respondsToSelector:@selector(presentingViewController)]) {
        
        isModal = ((self.presentingViewController && self.presentingViewController.modalViewController == self) ||
                   //or if I have a navigation controller, check if its parent modal view controller is self navigation controller
                   (self.navigationController && self.navigationController.presentingViewController && self.navigationController.presentingViewController.modalViewController == self.navigationController) ||
                   //or if the parent of my UITabBarController is also a UITabBarController class, then there is no way to do that, except by using a modal presentation
                   [[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]]);
        
    }
    
    return isModal;
}

- (IBAction)btnSubmit:(id)sender
{
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    
    [[CMSNetworkManager sharedManager] setRecoverPasswordDelegate:self];
    [[CMSNetworkManager sharedManager] recoverPasswordWithEmail:txtEmail.text onCompletion:nil onFaillure:nil showLoader:YES];
    
}

- (IBAction)btnCancel:(id)sender
{
    if ([self isPresentedAsModal]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)validateForm
{
    NSString *errorMessage;
    
    if (!(self.txtEmail.text.length >= 1)){
        errorMessage = @"Please enter Email address";
    }
    
    return errorMessage;
}

#pragma mark - TextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - CMSNetworkManager_RecoverPasswordDelegate methods

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didRecoverPasswordWithResponse:(NSDictionary *)response
{
    NSLog(@"Recover Password Request Successful");
    NSLog(@"%@",response);
    [[[UIAlertView alloc] initWithTitle:response[@"response_data"][@"message"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didFailToRecoverPasswordWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:nil message:@"Recover Password Request failed" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    NSLog(@"%@", error.description);
}

@end
