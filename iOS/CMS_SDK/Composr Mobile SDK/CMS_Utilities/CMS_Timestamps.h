//
//  CMS_Timestamps.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*
 
 CMS_Timestamps
 
 get_timezoned_date_time(int timestamp) - turns a unix timestamp into a written date&time, in the phone's timezone
 get_timezoned_date(int timestamp) - turns a unix timestamp into a written date, in the phone's timezone
 int time() - returns unix timestamp
 
 */

#import <Foundation/Foundation.h>

@interface CMS_Timestamps : NSObject

+ (NSString *)get_timezoned_date_time:(int)timestamp;
+ (NSString *)get_timezoned_date:(int)timestamp;
+ (int)time;

@end
