//
//  CMS_Users.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 04/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*
 
 CMS_Users
 
 bool has_page_access(page) - works using data retrieved when logging in
 bool has_privilege(string privilegeName) - works using data retrieved when logging in
 bool has_zone_access(string zoneName) - works using data retrieved when logging in
 bool is_staff() - works using data retrieved when logging in
 bool is_super_admin() - works using data retrieved when logging in
 int get_member() - works using data retrieved when logging in
 int get_session_id() - works using data retrieved when logging in
 string get_username() - works using data retrieved when logging in
 array get_members_groups() - works using data retrieved when logging in
 array get_members_groups_names() - works using data retrieved when logging in
 string get_value - gets a member setting (lots of these stored when logging in, using standard ad-hoc preferences mechanism)

 */

#import <Foundation/Foundation.h>

@interface CMS_Users : NSObject

+ (BOOL)has_page_access:(NSString *)page;
+ (BOOL)has_privilege:(NSString *)privilegeName;
+ (BOOL)has_zone_access:(NSString *)zoneName;
+ (BOOL)is_staff;
+ (BOOL)is_super_admin;
+ (int)get_member;
+ (int)get_session_id;
+ (NSString *)get_username;
+ (NSArray *)get_members_groups;
+ (NSArray *)get_members_groups_names;
+ (NSString *)get_value:(NSString *)key;
+ (NSString *)get_password;

@end
