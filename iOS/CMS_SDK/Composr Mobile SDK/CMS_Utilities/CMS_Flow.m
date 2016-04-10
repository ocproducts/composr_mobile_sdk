//
//  CMS_Flow.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMS_Flow.h"
#import "AppDelegate.h"
#import "CMSLoginViewController.h"

@implementation CMS_Flow

+ (void)access_denied{
    CMSLoginViewController *loginCntroller = [[CMSLoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginCntroller];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window.rootViewController presentViewController:navController animated:YES completion:nil];
}

/**
 *  Present an Alert with Title "Message"
 *
 *  @param msg Message to be displayed
 */
+ (void)attach_message:(NSString *)msg{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Message"
                                                     message:msg
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}

/**
 *  Present an Alert with Title "Message" and dismiss the calling view controller
 *
 *  @param msg            Message to be displayed
 *  @param viewController Calling view controller
 */
+ (void)inform_screen:(NSString *)msg :(UIViewController *)viewController{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Message"
                                                     message:msg
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  Present an Alert with Title "Warning" and dismiss the calling view controller
 *
 *  @param msg            Message to be displayed
 *  @param viewController Calling view controller
 */

+ (void)warn_screen:(NSString *)msg :(UIViewController *)viewController;{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Warning"
                                                     message:msg
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
    [viewController dismissViewControllerAnimated:YES completion:nil];

}

/**
 *  Transfers to a different view controller
 *
 *  @param sourceViewController Source view Controller
 *  @param viewController       Destination view Controller
 */
+ (void)redirect_screen:(UIViewController *)sourceViewController :(UIViewController *)viewController{
    [sourceViewController presentViewController:viewController animated:YES completion:nil];
}

@end
