//
//  CMS_Notification.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 21/01/15.
//  Copyright (c) 2015 Aaswini. All rights reserved.
//

#import "CMS_Notification.h"

@implementation CMS_Notification

/*
 Register Application for Remote Notifications
 */
+ (void)registerForRemoteNotifications
{
    UIApplication *application = [UIApplication sharedApplication];
    
    // Register for Push Notitications, if running iOS 8
#ifdef __IPHONE_8_0
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else{
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
#else
    {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
#endif
}

/*
 Parse device token from data
 */
+ (NSString *)parseDeviceToken:(NSData *)deviceToken{
    NSString *parsedDeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    parsedDeviceToken = [parsedDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@"parsedDeviceToken = %@",parsedDeviceToken);
    return parsedDeviceToken;
}

/*
 Save and send device token to CMS server
 */
+ (void) notifyDeviceTokenToServer:(NSString *)deviceToken{
    
    [[CMSNetworkManager sharedManager] savePushTokenWithToken:deviceToken onCompletion:^(NSDictionary *response) {
        DLog(@"Successfully saved push token to server");
        DLog(@"%@",response);
    } onFaillure:^(NSError *error) {
        DLog(@"%@", error.description);
    } showLoader:NO];
}

/*
 Parse and show alert from received notification
 */
+ (void) showNotification:(NSDictionary *)userInfo{
    NSString *message = nil;
    id alert = [userInfo[@"aps"] objectForKey:@"alert"];
    if ([alert isKindOfClass:[NSString class]]) {
        message = alert;
    } else if ([alert isKindOfClass:[NSDictionary class]]) {
        message = [alert objectForKey:@"body"];
    }
    if(!message){
        NSArray *body = userInfo[@"body"];
        if (body != nil && body.count > 0)
        {
            message = body[0];
        }
        
    }
    DLog(@" push message = %@",message);
    
    if (alert) {
        [[[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
}

@end
