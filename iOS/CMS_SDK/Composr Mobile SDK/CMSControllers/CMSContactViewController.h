//
//  ContactViewController.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 07/11/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMSNetworkManager.h"

#define STORYBOARD_ID_CMSContactViewController @"CMSContactViewController"

@interface CMSContactViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,CMSNetworkManager_FeedbackDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtSubject;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;

@property (weak, nonatomic) IBOutlet UILabel *lblSubject;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

- (IBAction)btnSave:(id)sender;

@end
