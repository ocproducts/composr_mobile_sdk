//
//  SignUpViewController.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 17/10/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMSSignUpViewController.h"
#import "CMS_Langs.h"

#define LABEL_SIGNUP_USERNAME         @"LABEL_SIGNUP_USERNAME"
#define LABEL_SIGNUP_PASSWORD         @"LABEL_SIGNUP_PASSWORD"
#define LABEL_SIGNUP_CONFIRM_PASSWORD @"LABEL_SIGNUP_CONFIRM_PASSWORD"
#define LABEL_SIGNUP_EMAIL            @"LABEL_SIGNUP_EMAIL"
#define LABEL_SIGNUP_CONFIRM_EMAIL    @"LABEL_SIGNUP_CONFIRM_EMAIL"
#define LABEL_SIGNUP_DOB              @"LABEL_SIGNUP_DOB"
#define BUTTON_SIGNUP_SIGNUP          @"BUTTON_SIGNUP_SIGNUP"
#define BUTTON_SIGNUP_CANCEL          @"BUTTON_SIGNUP_CANCEL"

@implementation CMSSignUpViewController {
    UIDatePicker* pickerView;
    NSDateFormatter *dateFormatter;
}

@synthesize txtUsername,txtPassword,txtConfirmPassword,txtEmail,txtConfirmEmail,txtDOB;

- (id) init{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:CMS_STORYBOARD_NAME bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:STORYBOARD_ID_CMSSignUpViewController];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.lblUsername setText:[CMS_Langs do_lang:LABEL_SIGNUP_USERNAME]];
    [self.lblPassword setText:[CMS_Langs do_lang:LABEL_SIGNUP_PASSWORD]];
    [self.lblConfirmPassword setText:[CMS_Langs do_lang:LABEL_SIGNUP_CONFIRM_PASSWORD]];
    [self.lblEmail setText:[CMS_Langs do_lang:LABEL_SIGNUP_EMAIL]];
    [self.lblConfirmEmail setText:[CMS_Langs do_lang:LABEL_SIGNUP_CONFIRM_EMAIL]];
    [self.lblDOB setText:[CMS_Langs do_lang:LABEL_SIGNUP_DOB]];
    [self.btnSignup setTitle:[CMS_Langs do_lang:BUTTON_SIGNUP_SIGNUP] forState:UIControlStateNormal];
    [self.btnCancel setTitle:[CMS_Langs do_lang:BUTTON_SIGNUP_CANCEL] forState:UIControlStateNormal];
    
    [self setTitle:@"Sign Up"];
    
    //setup date picker
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:[NSLocale systemLocale]];
    pickerView = [[UIDatePicker alloc] init];
    [pickerView setDatePickerMode:UIDatePickerModeDate];
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
    txtDOB.inputView = pickerView;
    txtDOB.inputAccessoryView = toolbar;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:tap];
}

- (void)singleTap {
    [self.view endEditing:YES];
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

-(void)doneClicked:(id) sender
{
    txtDOB.text = [dateFormatter stringFromDate:pickerView.date];
    [txtDOB resignFirstResponder]; //hides the pickerView
}

- (IBAction)dateChanged:(id)sender {
    txtDOB.text = [dateFormatter stringFromDate:pickerView.date];
}

- (IBAction)btnSignup:(id)sender
{
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    
    NSTimeZone *localTime = [NSTimeZone systemTimeZone];
    
    NSString *dob_day, *dob_month, *dob_year;
    NSArray *dobParts = [txtDOB.text componentsSeparatedByString:@"-"];
    dob_year = dobParts[0]; dob_month = dobParts[1]; dob_day = dobParts[2];
    
    [[CMSNetworkManager sharedManager] setRegisterDelegate:self];
    [[CMSNetworkManager sharedManager] registerWithUsername:txtUsername.text password:txtPassword.text confirmPassword:txtConfirmPassword.text email:txtEmail.text confirmEmail:txtConfirmEmail.text dob_day:dob_day dob_month:dob_month dob_year:dob_year timezone:localTime.name onCompletion:nil onFaillure:nil showLoader:YES];
}

- (IBAction)btnSignupCancel:(id)sender {
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
    
    NSString *regex = @"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (!(self.txtUsername.text.length >= 1)){
        errorMessage = @"Please enter a Username";
    } else if (!(self.txtPassword.text.length >= 5)){
        errorMessage = @"Please enter a Password with minimum of 5 letters";
    }else if (!([self.txtConfirmPassword.text isEqualToString:self.txtPassword.text])){
        errorMessage = @"Please correctly re-enter the password";
    } else if (![emailPredicate evaluateWithObject:self.txtEmail.text]){
        errorMessage = @"Please enter a valid email address";
    } else if (!([self.txtEmail.text isEqualToString:self.txtConfirmEmail.text])) {
        errorMessage = @"Please correctly re-enter the email address";
    } else if (!(self.txtDOB.text.length > 0)){
        errorMessage = @"Please enter your DOB";
    }
    
    return errorMessage;
}

#pragma mark - TextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtUsername) {
        [self.txtPassword becomeFirstResponder];
    } else if (textField == self.txtPassword) {
        [self.txtConfirmPassword becomeFirstResponder];
    } else if (textField == self.txtConfirmPassword) {
        [self.txtEmail becomeFirstResponder];
    } else if (textField == self.txtEmail) {
        [self.txtConfirmEmail becomeFirstResponder];
    } else if (textField == self.txtConfirmEmail) {
        [self.txtDOB becomeFirstResponder];
    } else if (textField == self.txtDOB) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - CMSNetworkManager_RegisterDelegate methods

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didRegisterWithResponse:(NSDictionary *)response
{
    NSLog(@"Register Successful");
    NSLog(@"%@",response);
    [[[UIAlertView alloc] initWithTitle:response[@"response_data"][@"message"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didFailToRegisterWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Register failed" message:error.domain delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    NSLog(@"%@", error.description);
}
@end
