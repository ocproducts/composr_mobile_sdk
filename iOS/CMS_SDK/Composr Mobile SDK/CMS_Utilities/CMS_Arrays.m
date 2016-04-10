//
//  CMS_Arrays.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMS_Arrays.h"
#import "CMS_Strings.h"

@implementation CMS_Arrays

/**
 *  Takes a list of maps and turns it into a simple list by extracting just one element from each map
 *
 *  @param key key for which value needs to be fetched
 *  @param arr source array containing many dictionaries
 *
 *  @return array of values corresponding to the specified key from each dictionary
 */
+ (NSArray *)collapse_1d_complexity:(NSString *)key :(NSArray *)arr{
    return [arr valueForKey:key];
}

/**
 *  Takes a list of maps and turns it into a simple dictionary by extracting just two elements from each dictionary.
 *
 *  @param keyKey key for which value to be fetched. This value is kept as key in the returning dictionary.
 *  @param valKey key for which value to be fetched to be kept as value for the first parameter in returning dictionary
 *  @param arr    source array of dictionaries
 *
 *  @return dictionary with keyvalue pair for the supplied keys from all dictionaries in the source array
 */
+ (NSDictionary *)collapse_2d_complexity:(NSString *)keyKey :(NSString *)valKey :(NSArray *)arr{
    NSMutableDictionary *result = [NSMutableDictionary new];
    for (NSDictionary *dict in arr) {
        NSString *key = [dict valueForKey:keyKey];
        NSString *value = [dict valueForKey:valKey];
        [result setObject:value forKey:key];
    }
    return result;
}

/**
 *  Returns an array by splitting the string with the supplied seperator
 *
 *  @param sep separator
 *  @param str source string
 *
 *  @return array of components in string by splitting with separator
 */
+ (NSArray *)explode:(NSString *)sep :(NSString *)str{
    return [str componentsSeparatedByString:sep];
}

/**
 *  Returns a string by joining the supplied array with the supplied seperator
 *
 *  @param sep separator
 *  @param arr source array
 *
 *  @return returns string by joining the components in the array with the separator
 */
+ (NSString *)implode:(NSString *)sep :(NSArray *)arr{
    return [arr componentsJoinedByString:sep];
}

/**
 *  Returns array of keys or values from a dictionary
 *
 *  @param useKey YES - returns array of keys, NO- returns array of values
 *  @param dict   source dictionary
 *
 *  @return returns array of keys or values from the dictionary
 */
+ (NSArray *)Array_values:(BOOL)useKey :(NSDictionary *)dict{
    NSMutableArray *result = [NSMutableArray new];
    for (NSString *key in dict.allKeys) {
        if (useKey) {
            [result addObject:key];
        }
        else{
            [result addObject:[dict valueForKey:key]];
        }
    }
    return result;
}

/**
 *  Returns if the array contains the given key
 *
 *  @param key   value to check for
 *  @param array source array
 *
 *  @return YES if array contains key else NO
 */
+ (BOOL)in_array:(id)key :(NSArray *)array {
    return [array containsObject:key];
}

/**
 *  Merges two arrays to a single array
 *
 *  @param array1 source array 1
 *  @param array2 source array 2
 *
 *  @return single array containing values of array1 and array2
 */
+ (NSArray *)array_merge:(NSArray *)array1 :(NSArray *)array2 {
    return [array1 arrayByAddingObjectsFromArray:array2];
}

/**
 *  Check of given map contains the given key
 *
 *  @param key String key to check for
 *  @param map source map
 *
 *  @return YES if map contains the key else NO
 */
+ (BOOL)array_key_exists:(id)key :(NSDictionary *)map {
    return [[map allKeys] containsObject:key];
}

/**
 *  Removes duplicate values from array
 *
 *  @param array source array
 *
 *  @return Returns array by removing duplicate values
 */
+ (NSArray *)array_unique:(NSArray *)array {
    return [[NSOrderedSet orderedSetWithArray:array] array];
}

/**
 *  Sorts the given array of maps based on value of a given key
 *
 *  @param array source array of maps
 *  @param key   key to sort the maps on
 */
+ (void)sort_maps_by:(NSArray **)array :(NSString *)key {
    *array = [*array sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2) {
        if (![obj1 isKindOfClass:[obj2 class]]) {
            return [[NSString stringWithFormat:@"%@",[obj1 objectForKey:key]] compare:[NSString stringWithFormat:@"%@",[obj2 objectForKey:key]] options:NSCaseInsensitiveSearch];
        }
        else if ([[obj1 objectForKey:key] isKindOfClass:[NSNumber class]]) {
            return [[obj1 objectForKey:key] compare:[obj2 objectForKey:key]];
        }
        return [[obj1 objectForKey:key] compare:[obj2 objectForKey:key] options:NSCaseInsensitiveSearch];
    }];
}

/**
 *  Sort array of strings or numbers
 *
 *  @param array source array of strings or numbers
 */
+ (void)sort:(id*)array {
    *array = [*array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (![obj1 isKindOfClass:[obj2 class]]) {
            return [[NSString stringWithFormat:@"%@",obj1] compare:[NSString stringWithFormat:@"%@",obj2] options:NSCaseInsensitiveSearch];
        }
        else if([obj1 isKindOfClass:[NSNumber class]]) {
            return [obj1 compare:obj2];
        }
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
}

/**
 *  Returns number of elements in an array or map
 *
 *  @param array source array or map
 *
 *  @return number of elements in array or map
 */
+ (int)count:(id)array {
    if ([array isKindOfClass:[NSArray class]]) {
        return (int)[(NSArray *)array count];
    }
    else if ([array isKindOfClass:[NSDictionary class]]) {
        return (int)[(NSDictionary *)array count];
    }
    else if ([array isKindOfClass:[NSString class]]) {
        return (int)[CMS_Strings strlen:array];
    }
    return 0;
}

/**
 *  Returns map corresponding to a key from array of maps
 *
 *  @param key  key
 *  @param dict array of maps
 *
 *  @return map
 */
+ (NSDictionary *) list_to_map:(NSString *)key :(NSArray *)dict{
    NSDictionary *ResultDict=[[NSDictionary alloc] init];
    ResultDict=[NSDictionary dictionaryWithObjects:dict forKeys:[dict valueForKey:key]];
    return ResultDict;
}

@end
