//
//  CMSLoginViewController.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 04/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMSLoginViewController.h"
#import "CMS_Langs.h"
#import "CMS_Flow.h"

#define LABEL_LOGIN_USERNAME    @"LABEL_LOGIN_USERNAME"
#define LABEL_LOGIN_PASSWORD    @"LABEL_LOGIN_PASSWORD"
#define BUTTON_LOGIN_LOGIN      @"BUTTON_LOGIN_LOGIN"

@implementation CMSLoginViewController

@synthesize lblUsername;
@synthesize lblPassword;
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize btnLogin;

- (id) init{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:CMS_STORYBOARD_NAME bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:STORYBOARD_ID_CMSLoginViewController];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Login"];
    
    if ([self isPresentedAsModal]) {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }
    
    [self.lblUsername setText:[CMS_Langs do_lang:LABEL_LOGIN_USERNAME]];
    [self.lblPassword setText:[CMS_Langs do_lang:LABEL_LOGIN_PASSWORD]];
    [self.btnLogin setTitle:[CMS_Langs do_lang:BUTTON_LOGIN_LOGIN] forState:UIControlStateNormal];
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

- (IBAction)cancel:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didFailToLogin)]) {
        [self.delegate didFailToLogin];
    }
    else{
        [CMS_Flow warn_screen:@"Login Cancelled" :self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)doLogin:(id)sender
{
    [self executeLogin];
}

- (void)executeLogin
{
    if(![self validateLoginFields]){
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Required Fields"
                                                         message:@"Username and password must both be filled in"
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    [[CMSNetworkManager sharedManager] setLoginDelegate:self];
    [[CMSNetworkManager sharedManager] loginWithUsername:txtUsername.text password:txtPassword.text onCompletion:nil onFaillure:nil showLoader:YES];
    
}

- (BOOL)validateLoginFields
{
    if([txtUsername.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""])
        return false;
    
    return true;
}

#pragma mark - TextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtUsername) {
        [self.txtPassword becomeFirstResponder];
    } else if (textField == self.txtPassword) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - CMSNetworkManager_LoginDelegate Methods

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didLoginWithResponse:(NSDictionary *)response
{
    NSLog(@"%@",response);
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didLogin)]) {
        [self.delegate didLogin];
    }
    else{
        [CMS_Flow inform_screen:@"Login Successful" :self];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    }
}

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didFailToLoginWithError:(NSError *)error
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didFailToLogin)]) {
        [self.delegate didFailToLogin];
    }
    else{
        [CMS_Flow warn_screen:[NSString stringWithFormat:@"Login Failed with Error : %@",error.domain] :self];
    }
}

@end
