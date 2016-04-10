//
//  CMS_SDK.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 23/01/15.
//  Copyright (c) 2015 Aaswini. All rights reserved.
//

#ifndef Composr_Mobile_SDK_CMS_SDK_h
#define Composr_Mobile_SDK_CMS_SDK_h
#endif

#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif

#import "CMS_Constants.h"
#import "Reachability.h"
#import "NSDictionary+Utility.h"
#import "NSString+MKNetworkKitAdditions.h"
#import "UIAlertView+MKNetworkKitAdditions.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
