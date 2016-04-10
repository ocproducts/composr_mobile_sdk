//
//  CMS_Arrays.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*
 
 CMS_Arrays
 
 array collapse_1d_complexity(string key, array arr) - takes a list of maps and turns it into a simple list by extracting just one element from each map
 map collapse_2d_complexity(string keyKey, string valKey, array arr) - takes a list of maps and turns it into a simple map by extracting just two elements from each map
 array explode(string sep, string str) - see the PHP manual
 string implode(string sep, array arr) - see the PHP manual
 
 */

#import <Foundation/Foundation.h>

@interface CMS_Arrays : NSObject

+ (NSArray *)collapse_1d_complexity:(NSString *)key :(NSArray *)arr;
+ (NSDictionary *)collapse_2d_complexity:(NSString *)keyKey :(NSString *)valKey :(NSArray *)arr;
+ (NSArray *)explode:(NSString *)sep :(NSString *)str;
+ (NSString *)implode:(NSString *)sep :(NSArray *)arr;

// returns values in the dictionary as list. If useKey, returns keys as list.
+ (NSArray *)Array_values:(BOOL)useKey :(NSDictionary *)dict;

+ (BOOL)in_array:(id)key :(NSArray *)array;
+ (NSArray *)array_merge:(NSArray *)array1 :(NSArray *)array2;
+ (BOOL)array_key_exists:(id)key :(NSDictionary *)map;
+ (NSArray *)array_unique:(NSArray *)array;
+ (void)sort_maps_by:(NSArray **)array :(NSString *)key;
+ (void)sort:(id*)array;
+ (int)count:(id)array;

+ (NSDictionary *) list_to_map:(NSString *)key :(NSArray *)dict;

@end
