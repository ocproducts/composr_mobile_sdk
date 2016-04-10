//
//  SignUpViewController.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 17/10/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMSNetworkManager.h"

#define STORYBOARD_ID_CMSSignUpViewController @"CMSSignUpViewController" 

@interface CMSSignUpViewController : UIViewController<UITextFieldDelegate,CMSNetworkManager_RegisterDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtDOB;

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirmEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblDOB;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)btnSignup:(id)sender;
- (IBAction)btnSignupCancel:(id)sender;

@end
