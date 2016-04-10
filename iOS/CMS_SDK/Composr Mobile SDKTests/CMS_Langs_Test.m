//
//  CMS_Langs_Test.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 07/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMS_Langs.h"

@interface CMS_Langs_Test : XCTestCase

@end

@implementation CMS_Langs_Test

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

- (void)test_do_lang
{
    NSString *expectedString = @"This is an example string";
    NSString *inputString = @"EXAMPLE_STRING";
    XCTAssertTrue([[CMS_Langs do_lang:inputString] isEqualToString:expectedString], @"");
}

- (void)test_do_lang_2
{
    NSString *expectedString = @"This is an example string";
    NSString *inputString = @"%@_%@";
    NSArray *inputParams = @[@"EXAMPLE",@"STRING"];
    XCTAssertTrue([[CMS_Langs do_lang:inputString :inputParams] isEqualToString:expectedString], @"");
}

@end
