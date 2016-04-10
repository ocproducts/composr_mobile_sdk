//
//  CMS_Strings.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMS_Strings.h"
#import "NSString+HTML.h"

@implementation CMS_Strings

/**
 *  Remove html tags from string
 *
 *  @param str source string
 *
 *  @return String after removing all html tags
 */
+ (NSString *)strip_tags:(NSString *)str{
    NSRange r;
    NSString *s = [str copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

/**
 *  Decode all html encoded values
 *
 *  @param str source string
 *
 *  @return String after decoding html encoded values
 */
+ (NSString *)html_entity_decode:(NSString *)str{
    return [str stringByDecodingHTMLEntities];
}

/**
 *  Format a floating point number
 *
 *  @param number                         source number
 *  @param decimalPoints                  Number of required decimal digits
 *  @param onlyIncludeNeededDecimalPoints YES - include decimals, NO - remove all decimal places
 *
 *  @return returns formatted number as string
 */
+ (NSString *)float_format:(double)number :(int)decimalPoints :(BOOL)onlyIncludeNeededDecimalPoints{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesSignificantDigits = NO;
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSeparator = @",";
    formatter.decimalSeparator = @".";
    formatter.maximumFractionDigits = 25 ;
    
    if (onlyIncludeNeededDecimalPoints) {
        formatter.maximumFractionDigits = decimalPoints;
    }
    
   return [formatter stringFromNumber:[NSNumber numberWithDouble:number]];
}

/**
 *  Returns position of a substring in string
 *
 *  @param searchIn  source string
 *  @param searchFor substring to search for
 *
 *  @return starting position of substring in the source string. -1 of not found.
 */
+ (int)strpos:(NSString *)searchIn :(NSString *)searchFor{
    NSRange range = [searchIn rangeOfString:searchFor];
    if (range.location == NSNotFound) {
        return -1;
    }
    return range.location;
}

/**
 *  Replace occurances of substring with a given string
 *
 *  @param search   substring
 *  @param replace  replace string
 *  @param searchIn source string
 *
 *  @return replaced string
 */
+ (NSString *)str_replace:(NSString *)search :(NSString *)replace :(NSString *)searchIn{
    return [searchIn stringByReplacingOccurrencesOfString:search withString:replace];
}

/**
 *  Returns a substring from string
 *
 *  @param searchIn source string
 *  @param offset   starting point of search
 *  @param length   length of substring
 *
 *  @return Returns substring from source string from the offset position to the length given
 */
+ (NSString *)substr:(NSString *)searchIn :(int)offset :(int)length{
    return [searchIn substringWithRange:NSMakeRange(offset,length)];
}

/**
 *  Trim whitespaces at the begenning and ending of a string
 *
 *  @param str source string
 *
 *  @return Returns trimmed string
 */
+ (NSString *)trim:(NSString *)str{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  Returns length of a string
 *
 *  @param str Input string
 *
 *  @return length of the input string
 */
+ (int)strlen:(NSString *)str {
    return (int)str.length;
}

/**
 *  Replaces arguments given into the string with placeholders
 *
 *  @param format    source string with place holders. eg: I like %@ and %@ .
 *  @param arguments values to be replaced into the string eq : [ "cats" , "dogs" ]
 *
 *  @return returned formatted string
 */
+ (NSString *)stringWithFormat:(NSString *)format array:(NSArray *)arguments
{
    if ( arguments.count > 10 ) {
        @throw [NSException exceptionWithName:NSRangeException reason:@"Maximum of 10 arguments allowed" userInfo:@{@"collection": arguments}];
    }
    NSArray* a = [arguments arrayByAddingObjectsFromArray:@[@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X"]];
    return [NSString stringWithFormat:format, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9] ];
}

@end
