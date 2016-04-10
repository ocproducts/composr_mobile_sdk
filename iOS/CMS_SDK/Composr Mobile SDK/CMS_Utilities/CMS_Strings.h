//
//  CMS_Strings.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*
 
 CMS_Strings
 
 string strip_tags(string str) - remove all HTML tags from the input string
 string html_entity_decode(string str) - convert common HTML entities to standard characters (e.g. "&amp;" becomes "&", "&ldquo;" becomes the unicode equivalent of that HTML entity)
 string float_format(float number, int decimalPoints, bool onlyIncludeNeededDecimalPoints) - formats a number nicely (e.g. with commas and decimal points)
 int strpos(string searchIn, string searchFor) - see the PHP manual
 string str_replace(string search, string replace, string searchIn) - see the PHP manual
 string substr(string searchIn, int offset, int length) - see the PHP manual
 string trim(string str) - see the PHP manual

 */

#import <Foundation/Foundation.h>

@interface CMS_Strings : NSObject

+ (NSString *)strip_tags:(NSString *)str;
+ (NSString *)html_entity_decode:(NSString *)str;
+ (NSString *)float_format:(double)number :(int)decimalPoints :(BOOL)onlyIncludeNeededDecimalPoints;
+ (int)strpos:(NSString *)searchIn :(NSString *)searchFor;
+ (NSString *)str_replace:(NSString *)search :(NSString *)replace :(NSString *)searchIn;
+ (NSString *)substr:(NSString *)searchIn :(int)offset :(int)length;
+ (NSString *)trim:(NSString *)str;
+ (int)strlen:(NSString *)str;

+ (NSString *)stringWithFormat:(NSString *)format array:(NSArray *)arguments;

@end
