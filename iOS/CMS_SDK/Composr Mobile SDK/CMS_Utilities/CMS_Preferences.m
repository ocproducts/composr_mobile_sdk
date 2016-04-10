//
//  CMS_Preferences.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMS_Preferences.h"

@implementation CMS_Preferences

/**
 *  Gets string value for a key from userdefaults
 *
 *  @param name Key key to check from defaults
 *
 *  @return string value for the supplied key in userdefaults
 */
+ (NSString *)get_value:(NSString *)name{
   return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}

/**
 *  Saves a value mapped to a key in user defaults
 *
 *  @param name  key key to which value is to be mapped
 *  @param value value to be saved
 */
+ (void)set_value:(NSString *)name :(NSString *)value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:name];
}

@end
