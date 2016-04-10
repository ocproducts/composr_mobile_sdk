//
//  CMS_Users.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 04/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMS_Users.h"
#import "CMS_Arrays.h"

@implementation CMS_Users

/**
 *  Returns if the user has page access
 *
 *  @param page Name of page to check for
 *
 *  @return YES if has page access, NO if not
 */
+ (BOOL)has_page_access:(NSString *)page {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:k_User_PagesBlacklist]) {
        NSArray *blackListedPages = [defaults objectForKey:k_User_PagesBlacklist];
        for (NSString *blackListedPage in blackListedPages) {
            if ([blackListedPage isEqualToString:page]) {
                return NO;
            }
        }
    }
    return YES;
}

/**
 *  Returns if the user has a particular privilage
 *
 *  @param privilegeName Name of the privilage
 *
 *  @return YES if has privilage, NO if not
 */
+ (BOOL)has_privilege:(NSString *)privilegeName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:k_User_Privileges]){
        NSArray *userPrivilages = [defaults objectForKey:k_User_Privileges];
        if ([userPrivilages containsObject:privilegeName]) {
            return YES;
        }
    }
    return NO;
}

/**
 *  Returns if a user has access to a particular zone
 *
 *  @param zoneName Name of the zone
 *
 *  @return YES if has zone access, NO if not
 */
+ (BOOL)has_zone_access:(NSString *)zoneName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:k_User_Zones]){
        NSArray *userZones = [defaults objectForKey:k_User_Zones];
        if ([userZones containsObject:zoneName]) {
            return YES;
        }
    }
    return NO;
}

/**
 *  Returns if a user is staff or not
 *
 *  @return YES if user is staff, NO if not
 */
+ (BOOL)is_staff{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:k_isStaff]){
        return [[defaults objectForKey:k_isStaff]boolValue];
    }
    return NO;
}

/**
 *  Returns if the user is a super admin or not ( Returns NO if user is staff )
 *
 *  @return YES if user is super admin, NO if not
 */
+ (BOOL)is_super_admin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:k_isSuperAdmin]){
        return ![CMS_Users is_staff];
    }
    return NO;
}

/**
 *  Returns the member id of the user retrieved from login data
 *
 *  @return member id of the user
 */
+(int)get_member{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:k_MemberID]){
        return [[defaults objectForKey:k_MemberID]intValue];
    }
    return -1;
}

/**
 *  Returns the session id of the user retrieved from login data
 *
 *  @return session id of the user
 */
+ (int)get_session_id{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:k_SessionID]){
        return [[defaults objectForKey:k_SessionID]intValue];
    }
    return -1;
}

/**
 *  Returns the username of the user
 *
 *  @return username of the user
 */
+ (NSString *)get_username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:k_Username]){
        return [defaults objectForKey:k_Username];
    }
    return @"";
}

/**
 *  Returns all the member groups retreived from the login data
 *
 *  @return Array of member groups
 */
+ (NSArray *)get_members_groups{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:k_Members_Groups]){
        return [defaults objectForKey:k_Members_Groups];
    }
    return @[];
}

/**
 *  Returns only names of the member groups retreived from the login data
 *
 *  @return Array of member group names
 */
+ (NSArray *)get_members_groups_names{
    return [CMS_Arrays collapse_1d_complexity:@"name" :[CMS_Users get_members_groups]];
}

/**
 *  Returns value for the key from user defaults
 *
 *  @param key Key
 *
 *  @return String Value for the key. @"" if nil.
 */
+ (NSString *)get_value:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:key]){
        return [defaults objectForKey:key];
    }
    return @"";
}

/**
 *  Returns password of user saved in user defaults
 *
 *  @return Password of the user
 */
+ (NSString *)get_password{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:k_Password]){
        return [defaults objectForKey:k_Password];
    }
    return @"";
}


@end