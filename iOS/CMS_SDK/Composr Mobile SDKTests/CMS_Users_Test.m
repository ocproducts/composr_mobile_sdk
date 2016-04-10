//
//  CMS_Users_Test.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 07/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMS_Users.h"
#import "CMS_Arrays.h"
#import "CMS_Preferences.h"

@interface CMS_Users_Test : XCTestCase

@end

@implementation CMS_Users_Test{
    NSArray *memberGroups;
}

- (void)setUp
{
    [super setUp];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@"121" forKey:k_MemberID];
    [defaults setObject:@[
                          @"page1",
                          @"page2"
                          ]
                 forKey:k_User_PagesBlacklist];
    
    NSArray *privilages = @[
                            @"privilege1",
                            @"privilege2"
                            ];
    [defaults setObject:privilages forKey:k_User_Privileges];
    
    NSArray *zones = @[
                       @"zone1",
                       @"zone2"
                       ];
    [defaults setObject:zones forKey:k_User_Zones];
    
    [defaults setObject:@"YES" forKey:k_isStaff];
    [defaults setObject:@"YES" forKey:k_isSuperAdmin];
    [defaults setObject:@"252" forKey:k_SessionID];
    [defaults setObject:@"testUser" forKey:k_Username];
    [defaults setObject:@"testPass" forKey:k_Password];
    
    memberGroups = @[
                     @{
                         @"name" : @"group1",
                         @"type" : @"testType"
                         },
                     @{
                         @"name" : @"group2",
                         @"type" : @"testType"
                         }
                     ];
    [defaults setObject:memberGroups forKey:k_Members_Groups];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_has_page_access
{
    XCTAssertTrue([CMS_Users has_page_access:@"page3"], @"");
    XCTAssertFalse([CMS_Users has_page_access:@"page2"], @"");
}

- (void)test_has_privilege
{
    XCTAssertTrue([CMS_Users has_privilege:@"privilege1"], @"");
    XCTAssertTrue([CMS_Users has_privilege:@"privilege2"], @"");
    XCTAssertFalse([CMS_Users has_privilege:@"privilege3"], @"");
}

- (void)test_has_zone_access
{
    XCTAssertTrue([CMS_Users has_zone_access:@"zone1"], @"");
    XCTAssertTrue([CMS_Users has_zone_access:@"zone2"], @"");
    XCTAssertFalse([CMS_Users has_zone_access:@"zone3"], @"");
}

- (void)test_is_staff
{
    XCTAssertTrue([CMS_Users is_staff], @"");
}

- (void)test_is_super_admin
{
    XCTAssertFalse([CMS_Users is_super_admin], @"");
}

- (void)test_get_member
{
    XCTAssertEqual([CMS_Users get_member], 121, @"");
}

- (void)test_get_session_id
{
    XCTAssertEqual([CMS_Users get_session_id], 252, @"");
}

- (void)test_get_username
{
    XCTAssertTrue([[CMS_Users get_username] isEqualToString:@"testUser"], @"");
}

- (void)test_get_members_groups
{
   XCTAssertTrue([[CMS_Users get_members_groups] isEqualToArray:memberGroups], @"");
}

- (void)test_get_members_groups_names
{
    XCTAssertTrue([[CMS_Users get_members_groups_names] isEqualToArray:[CMS_Arrays collapse_1d_complexity:@"name" :memberGroups]], @"");
}

- (void)test_get_value
{
    [CMS_Preferences set_value:@"testKey" :@"testValue"];
    XCTAssertTrue([[CMS_Users get_value:@"testKey"] isEqualToString:@"testValue"], @"");
}

- (void)test_get_password
{
    XCTAssertTrue([[CMS_Users get_password] isEqualToString:@"testPass"], @"");
}

@end
