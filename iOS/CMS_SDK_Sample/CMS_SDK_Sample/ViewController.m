//
//  ViewController.m
//  CMS_SDK_Sample
//
//  Created by Aaswini on 23/01/15.
//  Copyright (c) 2015 Aaswini. All rights reserved.
//

#import "ViewController.h"
#import "CMSLoginViewController.h"
#import "SignupViewController.h"
#import "CMSPasswordRecoverViewController.h"
#import "CMSFeedListViewController.h"
#import "FormViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doLogin:(id)sender{
    CMSLoginViewController *loginController = [[CMSLoginViewController alloc]init];
    [self.navigationController pushViewController:loginController animated:YES];
}

-(IBAction)doSignUp:(id)sender{
    SignupViewController *signupController = [[SignupViewController alloc]init];
    [self.navigationController pushViewController:signupController animated:YES];
}

-(IBAction)doPasswordRecover:(id)sender{
    CMSPasswordRecoverViewController *passwordRecoverController = [[CMSPasswordRecoverViewController alloc]init];
    [self.navigationController pushViewController:passwordRecoverController animated:YES];
}

-(IBAction)doFeed:(id)sender{
    CMSFeedListViewController *feedViewController = [[CMSFeedListViewController alloc]init];
    [self.navigationController pushViewController:feedViewController animated:YES];
}

-(IBAction)doCMSForm:(id)sender{
    FormViewController *formController = [[FormViewController alloc] init];
    [self.navigationController pushViewController:formController animated:YES];
}

@end
