//
//  CMS_Timestamps_Test.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 07/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMS_Timestamps.h"

@interface CMS_Timestamps_Test : XCTestCase

@end

@implementation CMS_Timestamps_Test

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

- (void)test_get_timezoned_date
{
    int timestamp = 1427209581;
    NSString *expectedOutput = @"Mar 24, 2015 - 20:36:21";
    XCTAssertTrue([expectedOutput isEqualToString:[CMS_Timestamps get_timezoned_date:timestamp :YES]]);
    NSString *expectedOutputWithoutTime = @"Mar 24, 2015";
    XCTAssertTrue([expectedOutputWithoutTime isEqualToString:[CMS_Timestamps get_timezoned_date:timestamp :NO]]);
}

- (void)test_time
{
    NSLog(@"current timestamp = %d", [CMS_Timestamps time]);
}

@end
