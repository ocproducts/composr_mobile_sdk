//
//  CMS_Database_Test.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 07/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMS_Database.h"

@interface CMS_Database_Test : XCTestCase

@end

@implementation CMS_Database_Test

- (void)setUp
{
    [super setUp];
    
    [CMS_Database initializeDatabase];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_add_table_field
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    [CMS_Database add_table_field:tableName :@"field3"];
    NSArray *resultFields = [CMS_Database getFieldNamesForTable:tableName];
    
    XCTAssertTrue([resultFields containsObject:@"field3"],@"Field was not added.");
    
    [CMS_Database drop_table_if_exists:tableName];
}

- (void)test_rename_table_field
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    [CMS_Database rename_table_field:tableName :@"field2" :@"field3"];
    NSArray *resultFields = [CMS_Database getFieldNamesForTable:tableName];
    
    XCTAssertTrue([resultFields containsObject:@"field3"],@"Field was not renamed.");
    XCTAssertFalse([resultFields containsObject:@"field2"],@"Old field still exists.");
    XCTAssertTrue([resultFields containsObject:@"field1"],@"Non renamed fields got deleted.");
    
    [CMS_Database drop_table_if_exists:tableName];
}

- (void)test_delete_table_field
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    [CMS_Database delete_table_field:tableName :@"field2"];
    NSArray *resultFields = [CMS_Database getFieldNamesForTable:tableName];
    
    XCTAssertFalse([resultFields containsObject:@"field2"],@"Field is not deleted.");
    XCTAssertFalse([resultFields containsObject:@"field3"],@"Oops. Where this field came from ??");
    XCTAssertTrue([resultFields containsObject:@"field1"],@"Non deleted fields got deleted.");
    
    [CMS_Database drop_table_if_exists:tableName];
}

- (void)test_create_table
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    NSArray *resultFields = [CMS_Database getFieldNamesForTable:tableName];
    
    XCTAssertFalse(resultFields.count == 0, @"Table not created");
    XCTAssertTrue(resultFields.count == 2, @"Not all fields added");
    XCTAssertTrue([resultFields[0] isEqualToString:@"field1"], @"field1 not found in table");
    XCTAssertTrue([resultFields[1] isEqualToString:@"field2"], @"field2 not found in table");
    
    [CMS_Database drop_table_if_exists:tableName];
}

- (void)test_drop_table_if_exists
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    NSArray *resultFields = [CMS_Database getFieldNamesForTable:tableName];
    
    XCTAssertFalse(resultFields.count == 0, @"Table not created. Then how will I check drop table ?");
    XCTAssertTrue(resultFields.count == 2, @"Not all fields added. So, create table went wrong. Please verify that first.");
    
    [CMS_Database drop_table_if_exists:tableName];
    
    resultFields = [CMS_Database getFieldNamesForTable:tableName];
    
    XCTAssertTrue(resultFields.count == 0, @"Table still has fields. Hence not dropped. I fail..");
}

- (void)test_db_escape_string
{
    NSString *inputString = @"Hifi.. ' this is a ' test db' string..'''";
    NSString *expectedOutput = @"Hifi.. '' this is a '' test db'' string..''''''";
    NSString *outputString = [CMS_Database db_escape_string:inputString];
    
    XCTAssertTrue([outputString isEqualToString:expectedOutput], @"I am not escaped..");
}

- (void)test_query
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    
    NSDictionary *row1 = @{
                           @"field1":@"value11",
                           @"field2":@"value12"
                           };
    NSDictionary *row2 = @{
                           @"field1":@"value21",
                           @"field2":@"value22"
                           };
    
    // Just to cross check this unit works before testing this module
    [self test_create_table];
    
    // Need to recreate the table as test_create_table will drop the table after testing
    [CMS_Database create_table:tableName :fields];
    
    [CMS_Database query_insert:tableName :row1];
    [CMS_Database query_insert:tableName :row2];
    
    NSString *query = [NSString stringWithFormat:@"select * from %@ where field1='value21'", tableName];
    NSArray *queryResult = [CMS_Database query:query];
    
    XCTAssertTrue(queryResult.count == 1, @"I expect only a single field.");
    
    XCTAssertTrue([queryResult[0][@"field1"] isEqualToString:@"value21"], @"This is not the value I expect for field1");
    XCTAssertTrue([queryResult[0][@"field2"] isEqualToString:@"value22"], @"This is not the value I expect for field2");
    
    [CMS_Database drop_table_if_exists:tableName];
}

- (void)test_query_delete
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    
    NSDictionary *row1 = @{
                           @"field1":@"value11",
                           @"field2":@"value12"
                           };
    NSDictionary *row2 = @{
                           @"field1":@"value21",
                           @"field2":@"value22"
                           };
    
    [CMS_Database query_insert:tableName :row1];
    [CMS_Database query_insert:tableName :row2];
    
    NSDictionary *deleteWhereMap = @{
                                     @"field2":@"value22"
                                     };
    [CMS_Database query_delete:tableName :deleteWhereMap];
    
    NSString *query = [NSString stringWithFormat:@"select * from %@;", tableName];
    NSArray *queryResult = [CMS_Database query:query];
    
    XCTAssertTrue(queryResult.count == 1, @"I expect only a single row as I have deleted the other.");
    
    XCTAssertTrue([queryResult[0][@"field1"] isEqualToString:@"value11"], @"This is not the value I expect for field1");
    XCTAssertTrue([queryResult[0][@"field2"] isEqualToString:@"value12"], @"This is not the value I expect for field2");
    
    XCTAssertFalse([queryResult[0][@"field1"] isEqualToString:@"value21"], @"How come this field is here ? I had deleted this row.");
    XCTAssertFalse([queryResult[0][@"field2"] isEqualToString:@"value22"], @"How come this field is here ? I had deleted this row.");
    
    [CMS_Database drop_table_if_exists:tableName];
}

- (void)test_query_insert
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    
    NSDictionary *row1 = @{
                           @"field1":@"value11",
                           @"field2":@"value12"
                           };
    NSDictionary *row2 = @{
                           @"field1":@"value21",
                           @"field2":@"value22"
                           };
    
    [CMS_Database query_insert:tableName :row1];
    [CMS_Database query_insert:tableName :row2];
    
    NSString *query = [NSString stringWithFormat:@"select * from %@;", tableName];
    NSArray *queryResult = [CMS_Database query:query];
    
    XCTAssertTrue(queryResult.count == 2, @"I had inserted 2. So, I want 2 rows here.");
    
    XCTAssertTrue([queryResult[0][@"field1"] isEqualToString:@"value11"], @"This is not what I inserted for field1 in first row.");
    XCTAssertTrue([queryResult[0][@"field2"] isEqualToString:@"value12"], @"This is not what I inserted for field2 in first row.");
    
    XCTAssertTrue([queryResult[1][@"field1"] isEqualToString:@"value21"], @"This is not what I inserted for field1 in second row.");
    XCTAssertTrue([queryResult[1][@"field2"] isEqualToString:@"value22"], @"This is not what I inserted for field2 in second row.");
    
    [CMS_Database drop_table_if_exists:tableName];
}

- (void)test_query_select
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    
    NSDictionary *row1 = @{
                           @"field1":@"value11",
                           @"field2":@"value12"
                           };
    NSDictionary *row2 = @{
                           @"field1":@"value21",
                           @"field2":@"value22"
                           };
    
    [CMS_Database query_insert:tableName :row1];
    [CMS_Database query_insert:tableName :row2];
    
    NSArray *queryResult = [CMS_Database query_select:tableName :@[@"field1"] :@{@"field2":@"value22"} :nil];
    
    XCTAssertTrue(queryResult.count == 1, @"My where condition should have selected one row. This is wrong..");
    
    XCTAssertFalse([queryResult[0][@"field1"] isEqualToString:@"value11"], @"value11 shouldn't be here. How did it come ?");
    XCTAssertFalse([[queryResult[0] allKeys] containsObject:@"field2"], @"I haven't selected field2. Why did it come in the result ?");
    
    XCTAssertTrue([queryResult[0][@"field1"] isEqualToString:@"value21"], @"I need to get value21 here. But it's not.");
    
    [CMS_Database drop_table_if_exists:tableName];
}

- (void)test_query_select_value
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    
    NSDictionary *row1 = @{
                           @"field1":@"value11",
                           @"field2":@"value12"
                           };
    NSDictionary *row2 = @{
                           @"field1":@"value21",
                           @"field2":@"value22"
                           };
    
    [CMS_Database query_insert:tableName :row1];
    [CMS_Database query_insert:tableName :row2];
    
    NSString *queryResult = [CMS_Database query_select_value:tableName :@"field2" :@{@"field1":@"value11"} :nil];
    NSString *expectedResult = @"value12";
    
    XCTAssertTrue([queryResult isEqualToString:expectedResult], @"This is not what I had expected");
    XCTAssertFalse([queryResult isEqualToString:@"value22"], @"This is not what I had expected");
    
    [CMS_Database drop_table_if_exists:tableName];
}

- (void)test_query_select_int_value
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    
    NSDictionary *row1 = @{
                           @"field1":@"value11",
                           @"field2":@"12"
                           };
    NSDictionary *row2 = @{
                           @"field1":@"value21",
                           @"field2":@"22"
                           };
    NSDictionary *row3 = @{
                           @"field1":@"value31",
                           @"field2":@"value32"
                           };
    
    [CMS_Database query_insert:tableName :row1];
    [CMS_Database query_insert:tableName :row2];
    [CMS_Database query_insert:tableName :row3];
    
    int queryResult = [CMS_Database query_select_int_value:tableName :@"field2" :@{@"field1":@"value11"} :nil];
    int expectedResult = 12;
    
    XCTAssertTrue(queryResult == expectedResult, @"This is not what I had expected");
    
    queryResult = [CMS_Database query_select_int_value:tableName :@"field3" :@{@"field1":@"value11"} :nil];
    expectedResult = -1;
    
    XCTAssertTrue(queryResult == expectedResult, @"I expect -1 if the field is not available or any error occured.");
    
    queryResult = [CMS_Database query_select_int_value:tableName :@"field2" :@{@"field1":@"value21"} :nil];
    expectedResult = 22;
    
    XCTAssertTrue(queryResult == expectedResult, @"This is not what I had expected");
    
    queryResult = [CMS_Database query_select_int_value:tableName :@"field2" :@{@"field1":@"value31"} :nil];
    expectedResult = 0;
    
    XCTAssertTrue(queryResult == expectedResult, @"I expect 0 for a non integer field");
    
    [CMS_Database drop_table_if_exists:tableName];
}

- (void)test_query_update
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    
    NSDictionary *row1 = @{
                           @"field1":@"value11",
                           @"field2":@"12"
                           };
    NSDictionary *row2 = @{
                           @"field1":@"value21",
                           @"field2":@"22"
                           };
    NSDictionary *row3 = @{
                           @"field1":@"value31",
                           @"field2":@"value32"
                           };
    
    [CMS_Database query_insert:tableName :row1];
    [CMS_Database query_insert:tableName :row2];
    [CMS_Database query_insert:tableName :row3];
    
    [CMS_Database query_update:tableName :@{@"field2":@"40"} :@{@"field1":@"value31"}];
    
    int queryResult = [CMS_Database query_select_int_value:tableName :@"field2" :@{@"field1":@"value31"} :nil];
    int expectedResult = 40;
    
    XCTAssertTrue(queryResult == expectedResult, @"I expect 40 here as I had updated it.");
    
    queryResult = [CMS_Database query_select_int_value:tableName :@"field2" :@{@"field1":@"value11"} :nil];
    expectedResult = 40;
    
    XCTAssertTrue(queryResult != expectedResult && queryResult == 12, @"I donot expect 40 here rather I want 12.");
    
    [CMS_Database drop_table_if_exists:tableName];
}

- (void) test_getFieldNamesForTable
{
    NSString *tableName = @"testTable";
    NSArray *fields = @[
                        @"field1",
                        @"field2"
                        ];
    
    [CMS_Database create_table:tableName :fields];
    
    NSArray *fieldNames = [CMS_Database getFieldNamesForTable:tableName];
    
    XCTAssertTrue(fieldNames.count == 2, @"I had made two fields. Where are they ?");
    XCTAssertTrue([fieldNames[0] isEqualToString:@"field1"], @"This is not my first field");
    XCTAssertTrue([fieldNames[1] isEqualToString:@"field2"], @"This is not my second field");
    XCTAssertFalse([fieldNames containsObject:@"field3"], @"I haven't entered this kind of a field.");
    
    [CMS_Database drop_table_if_exists:tableName];
}

@end
