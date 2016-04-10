//
//  AppDelegate.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 04/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "AppDelegate.h"
#import "CMS_Notification.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CMSNetworkManager sharedManagerWithUrl:k_WEBSERVICES_DOMAIN];
    [CMS_Notification registerForRemoteNotifications];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // To clear any existing badges and notifications when app entering foreground
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark RemoteNotificationRegister Callback Methods

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *parsedDeviceToken = [CMS_Notification parseDeviceToken:deviceToken];
    [CMS_Notification notifyDeviceTokenToServer:parsedDeviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (error.code == 3010) {
        DLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        //TODO: Show an alert or log regarding the error
        DLog(@"%@",error.description);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DLog(@"userinfor = %@",userInfo);
    
    if([application applicationState] == UIApplicationStateInactive)
    {
        DLog(@"Received notifications while inactive.");
    }
    else{
        DLog(@"Received notifications while active.");
    }
}

@end
