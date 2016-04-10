//
//  CMS_Arrays_Test.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 07/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMS_Arrays.h"

@interface CMS_Arrays_Test : XCTestCase

@end

@implementation CMS_Arrays_Test

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

- (void)test_collapse_1d_complexity
{
    NSArray *inputArray = @[
                            @{
                                @"id" : @"1",
                                @"title" : @"India"
                                },
                            @{
                                @"id" : @"2",
                                @"title" : @"Pakistan"
                                }
                            
                            ];
    NSString *inputKey = @"title";
    
    NSArray *expectedOtput = @[@"India",@"Pakistan"];
    
    XCTAssertTrue([expectedOtput isEqualToArray:[CMS_Arrays collapse_1d_complexity:inputKey :inputArray]], @"");
}

- (void)test_collapse_2d_complexity
{
    NSArray *inputArray = @[
                            @{
                                @"id" : @"1",
                                @"title" : @"India"
                                },
                            @{
                                @"id" : @"2",
                                @"title" : @"Pakistan"
                                }
                            
                            ];
    NSString *inputKeyKey = @"id";
    NSString *inputKeyVal = @"title";
    
    NSDictionary *expectedOtput = @{
                                    @"1" : @"India",
                                    @"2" : @"Pakistan"
                                    };
    
    XCTAssertTrue([expectedOtput isEqualToDictionary:[CMS_Arrays collapse_2d_complexity:inputKeyKey :inputKeyVal :inputArray]], @"");
}

- (void)test_explode
{
    NSArray *expectedArray = @[@"This",@"is",@"an",@"example",@"string"];
    NSArray *testArray = [CMS_Arrays explode:@"-" :@"This-is-an-example-string"];
    XCTAssertTrue([expectedArray isEqualToArray:testArray], @"Arrays are not equal : \"%@\" , \"%@\"", expectedArray, testArray);
}

- (void)test_implode
{
    NSString *expectedString = @"This-is-an-example-string";
    NSString *testString = [CMS_Arrays implode:@"-" :@[@"This",@"is",@"an",@"example",@"string"]];
    XCTAssertTrue([expectedString isEqualToString:testString], @"Strings are not equal : \"%@\" , \"%@\"", expectedString, testString);
}

- (void)test_map_to_list
{
    NSDictionary *dict = @{
                           @"key1":@"val1",
                           @"key2":@"val2"
                           };
    NSArray *result = [CMS_Arrays Array_values:NO :dict];
    
    XCTAssertTrue(result.count == 2, @"I expected 2 here..");
    XCTAssertTrue([result containsObject:@"val1"], @"I had val1");
    XCTAssertFalse([result containsObject:@"key1"], @"I didn't want keys in the result");
    
    result = [CMS_Arrays Array_values:YES :dict];
    
    XCTAssertTrue(result.count == 2, @"I expected 2 here..");
    XCTAssertTrue([result containsObject:@"key2"], @"I had added key2");
    XCTAssertFalse([result containsObject:@"val1"], @"I didn't want values in the result");
}

- (void)test_in_array {
    NSArray *inputArray = @[@1, @2, @"3", @"test", @5.3];
    
    XCTAssertTrue([CMS_Arrays in_array:@1 :inputArray]);
    XCTAssertTrue([CMS_Arrays in_array:@(1) :inputArray]);
    XCTAssertFalse([CMS_Arrays in_array:@"1" :inputArray]);
    XCTAssertTrue([CMS_Arrays in_array:@2 :inputArray]);
    XCTAssertTrue([CMS_Arrays in_array:@"3" :inputArray]);
    XCTAssertTrue([CMS_Arrays in_array:@5.3 :inputArray]);
    XCTAssertFalse([CMS_Arrays in_array:@5.6 :inputArray]);
    XCTAssertFalse([CMS_Arrays in_array:@"" :inputArray]);
    XCTAssertFalse([CMS_Arrays in_array:@1 :nil]);
    XCTAssertFalse([CMS_Arrays in_array:nil :nil]);
}

- (void)test_array_merge {
    NSArray *inputArray1 = @[@1, @2, @"3", @"test", @5.3];
    NSArray *inputArray2 = @[@6, @2, @"fdfd"];
    
    XCTAssertTrue([CMS_Arrays array_merge:inputArray1 :inputArray2].count == 8);
    XCTAssertTrue([[CMS_Arrays array_merge:inputArray1 :inputArray2][0] isEqual:@1]);
    XCTAssertTrue([[CMS_Arrays array_merge:inputArray1 :inputArray2][5] isEqual:@6]);
    XCTAssertTrue([[CMS_Arrays array_merge:inputArray1 :inputArray2][7] isEqual:@"fdfd"]);
    XCTAssertFalse([[CMS_Arrays array_merge:inputArray1 :inputArray2][3] isEqual:@"tes"]);
    XCTAssertTrue([CMS_Arrays array_merge:inputArray1 :nil].count == 5);
    XCTAssertTrue([[CMS_Arrays array_merge:inputArray1 :nil][3] isEqual:@"test"]);
    XCTAssertTrue([CMS_Arrays array_merge:nil :nil].count == 0);
}

- (void)test_array_key_exists {
    NSDictionary *inputMap =  @{
                                @"key1":@"val1",
                                @"key2":@"val2",
                                @1:@"val3",
                                @"":@"val4",
                                @3.5:@"val5",
                                @"3.6":@"val6"
                                };
    
    XCTAssertTrue([CMS_Arrays array_key_exists:@"key1" :inputMap]);
    XCTAssertTrue([CMS_Arrays array_key_exists:@3.5 :inputMap]);
    XCTAssertFalse([CMS_Arrays array_key_exists:@3 :inputMap]);
    XCTAssertFalse([CMS_Arrays array_key_exists:@1 :nil]);
    XCTAssertFalse([CMS_Arrays array_key_exists:@3 :inputMap]);
    XCTAssertFalse([CMS_Arrays array_key_exists:@3.6 :inputMap]);
    XCTAssertTrue([CMS_Arrays array_key_exists:@"3.6" :inputMap]);
    XCTAssertTrue([CMS_Arrays array_key_exists:@"" :inputMap]);
    XCTAssertFalse([CMS_Arrays array_key_exists:nil :nil]);
}

- (void)test_array_unique {
    NSArray *inputArray = @[@1, @2, @2, @"3", @"test", @5.3, @"test", @3];
    
    XCTAssertTrue([CMS_Arrays array_unique:inputArray].count == 6);
    XCTAssertTrue([CMS_Arrays array_unique:nil].count == 0);
    
    XCTAssertFalse([[CMS_Arrays array_unique:inputArray][2] isEqual:@2]);
    XCTAssertTrue([[CMS_Arrays array_unique:inputArray][2] isEqual:@"3"]);
}

- (void)test_sort_maps_by {
    NSArray *inputArray = @[
                            @{
                                @"id":@1,
                                @"val":@"val5"
                                },
                            @{
                                @"id":@3,
                                @"val":@"val2"
                                },
                            @{
                                @"id":@0,
                                @"val":@"Val9"
                                }
                            ];
    
    [CMS_Arrays sort_maps_by:&inputArray :@"id"];
    
    XCTAssertTrue([inputArray[0][@"id"] isEqual:@0]);
    XCTAssertTrue([inputArray[0][@"val"] isEqual:@"Val9"]);
    XCTAssertTrue([inputArray[2][@"id"] isEqual:@3]);
    XCTAssertTrue([inputArray[2][@"val"] isEqual:@"val2"]);
    
    XCTAssertFalse([inputArray[0][@"id"] isEqual:@1]);
    XCTAssertFalse([inputArray[0][@"val"] isEqual:@"val5"]);
    
    [CMS_Arrays sort_maps_by:&inputArray :@"val"];
    
    XCTAssertTrue([inputArray[0][@"id"] isEqual:@3]);
    XCTAssertTrue([inputArray[0][@"val"] isEqual:@"val2"]);
    XCTAssertTrue([inputArray[2][@"id"] isEqual:@0]);
    XCTAssertTrue([inputArray[2][@"val"] isEqual:@"Val9"]);
    
    XCTAssertFalse([inputArray[0][@"id"] isEqual:@0]);
    XCTAssertFalse([inputArray[0][@"val"] isEqual:@"Val9"]);
}

- (void)test_sort {
    NSArray *array = @[@4, @"-1", @"1", @0];
    
    [CMS_Arrays sort:&array];
    
    XCTAssertTrue([array[0] isEqual:@"-1"]);
    XCTAssertTrue([array[3] isEqual:@4]);
    XCTAssertFalse([array[0] isEqual:@4]);
}

- (void)test_count {
    NSArray *array = @[@4, @"-1", @"1", @0];
    NSDictionary *map = @{
                          @"key1":@"val1",
                          @"key2":@"val2",
                          @"key3":@"val3",
                          @"key4":@"val4",
                          @"key5":@"val5"
                          };
    
    XCTAssertTrue([CMS_Arrays count:array] == 4);
    XCTAssertTrue([CMS_Arrays count:map] == 5);
    XCTAssertTrue([CMS_Arrays count:nil] == 0);
    XCTAssertTrue([CMS_Arrays count:@"test"] == 4);
}

- (void)test_list_to_map
{
    NSArray *inputList = @[
                           @{
                               @"id" : @"1",
                               @"val" : @"val1"
                               },
                           @{
                               @"id" : @"2",
                               @"val" : @"val2"
                               },
                           @{
                               @"id" : @"3",
                               @"val" : @"val3"
                               }
                           ];
    
    NSDictionary *expectedOutputMap = @{
                                        @"1" : @{
                                                @"id" : @"1",
                                                @"val" : @"val1"
                                                },
                                        @"2" : @{
                                                @"id" : @"2",
                                                @"val" : @"val2"
                                                },
                                        @"3" : @{
                                                @"id" : @"3",
                                                @"val" : @"val3"
                                                }
                                        };
    
    XCTAssertTrue([[CMS_Arrays list_to_map:@"id" :inputList] isEqualToDictionary:expectedOutputMap]);
}

@end
