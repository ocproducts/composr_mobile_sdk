//
//  CMS_Flow.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*
 
 CMS_Flow
 
 void access_denied() - opens the login view controller, and then have that controller close and the opener view controller refresh
 void attach_message(string msg) - creates a popup alert, alert title is 'Message'
 void inform_screen(string msg) - creates a popup alert then closes the view controller, alert title is 'Message'
 void warn_screen(string msg) - creates a popup alert then closes the view controller, alert title is 'Warning'
 void redirect_screen(className viewController) - transfers to a different view controller
 
 */

#import <Foundation/Foundation.h>

@interface CMS_Flow : NSObject

+ (void)access_denied;
+ (void)attach_message:(NSString *)msg;
+ (void)inform_screen:(NSString *)msg :(UIViewController *)viewController;
+ (void)warn_screen:(NSString *)msg :(UIViewController *)viewController;
+ (void)redirect_screen:(UIViewController *)sourceViewController :(UIViewController *)viewController;

@end
