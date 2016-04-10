//
//  CMSLoginViewController.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 04/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMSNetworkManager.h"

#define STORYBOARD_ID_CMSLoginViewController @"CMSLoginViewController"

@protocol CMS_LoginViewController_Delegate <NSObject>

@optional
- (void)didLogin;
- (void)didFailToLogin;

@end

@interface CMSLoginViewController : UIViewController<UITextFieldDelegate,CMSNetworkManager_LoginDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UILabel *lblPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) id<CMS_LoginViewController_Delegate> delegate;

- (IBAction)doLogin:(id)sender;

@end
