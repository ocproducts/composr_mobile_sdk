//
//  CMS_Timestamps.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*
 
 CMS_Timestamps
 
 get_timezoned_date(int timestamp, bool includeTime) - turns a unix timestamp into a written date or date&time, in the phone's timezone
 int time() - returns unix timestamp
 
 */

#import <Foundation/Foundation.h>

@interface CMS_Timestamps : NSObject

+ (NSString *)get_timezoned_date:(int)timestamp :(BOOL)includeTime;
+ (int)time;

@end
