//
//  CMSPasswordRecoverViewController.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 17/10/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMSNetworkManager.h"

#define STORYBOARD_ID_CMSPasswordRecoverViewController @"CMSPasswordRecoverViewController"

@interface CMSPasswordRecoverViewController :UIViewController<UITextFieldDelegate,CMSNetworkManager_RecoverPasswordDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UILabel *lblForgotPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)btnSubmit:(id)sender;
- (IBAction)btnCancel:(id)sender;

@end
