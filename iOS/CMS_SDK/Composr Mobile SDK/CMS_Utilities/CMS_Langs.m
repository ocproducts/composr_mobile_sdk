//
//  CMS_Langs.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMS_Langs.h"
#import "CMS_Strings.h"

@implementation CMS_Langs

/**
 *  returns localized value of the supplied key string
 *
 *  @param key key to search in localization.strings
 *
 *  @return returns matching localized value of the key from localization.strings
 */
+ (NSString *)do_lang:(NSString *)key{
    return NSLocalizedString(key, @"");
}

/**
 *  returns localized value of the supplied key string
 *
 *  @param strName    source string
 *  @param parameters parameters to be replaced in string
 *
 *  @return returns matching localized value of the string replaced with parameters from localization.strings
 */
+ (NSString *)do_lang:(NSString *)strName :(NSArray *)parameters{
    return NSLocalizedString([CMS_Strings stringWithFormat:strName array:parameters], @"");
}

@end
