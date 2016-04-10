//
//  CMS_Strings_Test.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 07/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMS_Strings.h"

@interface CMS_Strings_Test : XCTestCase

@end

@implementation CMS_Strings_Test

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

- (void)test_strip_tags
{
    NSString *inputString = @"<html><head><title>Title</title></head><body>My test</br>html Page</body></html>";
    NSString *expectedOutput = @"TitleMy testhtml Page";
    XCTAssertTrue([[CMS_Strings strip_tags:inputString] isEqualToString:expectedOutput], @"");
}

- (void)test_html_entity_decode
{
    NSString *inputString = @"&ldquo;I love cats &amp; dogs&ldquo;";
    NSString *expectedOutput = @"“I love cats & dogs“";
    XCTAssertTrue([[CMS_Strings html_entity_decode:inputString] isEqualToString:expectedOutput], @"");
}

- (void)test_float_format
{
    double input = 12345678.012110;
    XCTAssertTrue([[CMS_Strings float_format:input :0 :NO] isEqualToString:@"12,345,678.01211"], @"");
    XCTAssertTrue([[CMS_Strings float_format:input :0 :YES] isEqualToString:@"12,345,678"], @"");
    XCTAssertTrue([[CMS_Strings float_format:input :2 :YES] isEqualToString:@"12,345,678.01"], @"");}

- (void)test_strpos
{
    NSString *inputString = @"I love cats and dogs";
    XCTAssertEqual([CMS_Strings strpos:inputString :@"love"], 2, @"");
    XCTAssertEqual([CMS_Strings strpos:inputString :@"s"], 10, @"");}

- (void)test_str_replace
{
    NSString *inputString = @"I love cats and dogs";
    NSString *expectedOutput = @"I love cats and birds";
    XCTAssertTrue([[CMS_Strings str_replace:@"dogs" :@"birds" :inputString] isEqualToString:expectedOutput], @"");}

- (void)test_substr
{
    NSString *inputString = @"I love cats and dogs";
    NSString *expectedOutput = @"and dogs";
    XCTAssertTrue([[CMS_Strings substr:inputString :12 :8] isEqualToString:expectedOutput], @"");}

- (void)test_trim
{
    NSString *inputString = @"   I love cats and dogs     \n \r \t  ";
    NSString *expectedOutput = @"I love cats and dogs";
    XCTAssertTrue([[CMS_Strings trim:inputString] isEqualToString:expectedOutput], @"");
}

- (void)test_strlen {
    NSString *inputString = @"   I love cats and dogs     \n \r \t  ";
    XCTAssertTrue([CMS_Strings strlen:inputString] == 35);
    XCTAssertFalse([CMS_Strings strlen:inputString] == 38);
    XCTAssertTrue([CMS_Strings strlen:nil] == 0);
}

-(void)test_stringWithFormat
{
    NSString *inputString = @"I like %@ and %@.";
    NSArray *arguments = @[
                           @"cats",
                           @"dogs"
                           ];
    NSString *expectedOutput = @"I like cats and dogs.";
    
    NSString *output = [CMS_Strings stringWithFormat:inputString array:arguments];
    XCTAssertTrue([expectedOutput isEqualToString:output], @"This is not what I expected.");
}

@end
