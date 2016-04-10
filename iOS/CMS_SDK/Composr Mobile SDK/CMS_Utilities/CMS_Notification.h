//
//  CMS_Notification.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 21/01/15.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMS_Users.h"
#import "CMSNetworkManager.h"

@interface CMS_Notification : NSObject

+ (void)registerForRemoteNotifications;
+ (NSString *)parseDeviceToken:(NSData *)deviceToken;
+ (void) notifyDeviceTokenToServer:(NSString *)deviceToken;
+ (void) showNotification:(NSDictionary *)userInfo;

@end
