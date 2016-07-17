//
//  CMS_Timestamps.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMS_Timestamps.h"

@implementation CMS_Timestamps

/**
 *  Turns a unix timestamp into a written date&time, in the phone's timezone
 *
 *  @param timestamp   unix timestamp to be converted
 *  @param includeTime should time be considered from the timestamp ? YES - consider time, NO - discard time
 *
 *  @return String representation of the supplied timestamp
 */
+ (NSString *)get_timezoned_date_time:(int)timestamp{
    NSDate *localDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy - HH:mm:ss"];
    return [dateFormatter stringFromDate:localDate];
}

/**
 *  Turns a unix timestamp into a written date, in the phone's timezone
 *
 *  @param timestamp   unix timestamp to be converted
 *  @param includeTime should time be considered from the timestamp ? YES - consider time, NO - discard time
 *
 *  @return String representation of the supplied timestamp
 */
+ (NSString *)get_timezoned_date:(int)timestamp{
    NSDate *localDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    return [dateFormatter stringFromDate:localDate];
}

/**
 *  Returns unix timestamp
 *
 *  @return returns unix timestamp
 */
+ (int)time{
    return [[NSDate date] timeIntervalSince1970];
}

@end
