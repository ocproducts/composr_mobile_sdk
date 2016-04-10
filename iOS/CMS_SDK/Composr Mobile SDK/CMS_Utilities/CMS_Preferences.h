//
//  CMS_Preferences.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*
 
 CMS_Preferences
 
 string get_value - gets an ad-hoc preference value
 set_value(string name, string value) - sets an ad-hoc preference value

 */

#import <Foundation/Foundation.h>

@interface CMS_Preferences : NSObject

+ (NSString *)get_value:(NSString *)string;
+ (void)set_value:(NSString *)name :(NSString *)value;



@end
