//
//  CMS_Preferences_Test.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 07/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMS_Preferences.h"

@interface CMS_Preferences_Test : XCTestCase

@end

@implementation CMS_Preferences_Test

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_get_value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *testKey = @"myTestKey";
    NSString *testVal = @"myTestVal";
    [defaults setObject:@"myTestVal" forKey:testKey];
    XCTAssertTrue([[CMS_Preferences get_value:testKey] isEqualToString:testVal], @"");
    [defaults removeObjectForKey:testKey];
}

- (void)test_set_value
{
    NSString *testKey = @"myTestKey";
    NSString *testVal = @"myTestVal";
    [CMS_Preferences set_value:testKey :testVal];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    XCTAssertTrue([[defaults objectForKey:testKey] isEqualToString:testVal], @"");
    [defaults removeObjectForKey:testKey];
}

@end
