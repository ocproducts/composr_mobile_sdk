//
//  CMS_HTTP_Test.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 07/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMS_HTTP.h"

@interface CMS_HTTP_Test : XCTestCase

@end

@implementation CMS_HTTP_Test

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

- (void)test_rawurlencode
{
    NSString *inputString = @"test encoding the url + something";
    NSString *expectedOutput = @"test%20encoding%20the%20url%20%2B%20something";
    XCTAssertTrue([[CMS_HTTP rawurlencode:inputString] isEqualToString:expectedOutput], @"");
}

- (void)test_json_decode
{
    NSString *jsonString = @"{\"test\":\"val\",\"test1\":\"val1\"}";
    id obj = [CMS_HTTP json_decode:jsonString];
    NSDictionary *expectedOutput = @{
                                     @"test" : @"val",
                                     @"test1" : @"val1"
                                     };
    XCTAssertTrue([obj isEqualToDictionary:expectedOutput], @"");
}

- (void)test_json_encode
{
    NSDictionary *inputDict = @{
                                @"test" : @"val",
                                @"test1" : @"val1"
                                };
    NSString *expectedOutput = @"{\"test1\":\"val1\",\"test\":\"val\"}";
    XCTAssertTrue([[CMS_HTTP json_encode:inputDict] isEqualToString:expectedOutput], @"");
}

- (void)test_get_base_url
{
    XCTAssertTrue([[CMS_HTTP get_base_url] isEqualToString:k_WEBSERVICES_DOMAIN], @"");
}

- (void)test_build_url
{
    NSString *testUrl = [CMS_HTTP build_url:@{@"param1":@"value1",@"param2":@"value2"} :@"testZone"];
    NSString *expectedUrl = [NSString stringWithFormat:@"%@/testZone/index.php?&param2=value2&param1=value1",k_WEBSERVICES_DOMAIN];
    XCTAssertTrue([testUrl isEqualToString:expectedUrl], @"");
}

- (void)test_http_download_file
{
    NSString *url = @"http://login.yahoo.com/config/login?";
    [CMS_HTTP http_download_file:url :YES :nil :kHTTPTimeout :^(NSString *response) {
        NSLog(@"%@",response);
    }];
    
    //TODO: Need to find a way to test the completion handler.
    XCTFail(@"Testcase not implemented");
}

- (void)test_has_network_connection
{
    XCTAssertTrue([CMS_HTTP has_network_connection] == YES, @"I have a network connection. Why do you say NO ?");
}

@end
