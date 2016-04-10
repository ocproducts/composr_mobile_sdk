//
//  CMS_Database.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*
 
 CMS_Database (should work via SQLite which doesn't really use field types so we will ignore those)
 
 void add_table_field(string tableName, string fieldName)
 void rename_table_field(string tableName, string oldFieldName, string newFieldName)
 void delete_table_field(string tableName, string fieldName)
 void create_table(string tableName, array fieldNames)
 void drop_table_if_exists(string tableName)
 string db_escape_string(string value)
 array query(string query)
 void query_delete(string tableName, map whereMap)
 void query_insert(string tableName, map valueMap)
 array query_select(string tableName, array selectList, map whereMap, string extraSQL)
 string query_select_value(string tableName, string selectFieldName, map whereMap, string extraSQL) - returns blank if no match
 int query_select_int_value(string tableName, string selectFieldName, map whereMap, string extraSQL) - returns -1 if no match
 void query_update(string tableName, map valueMap, map whereMap)
 
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>

typedef void (^CMSDatabaseUpgradeBlock)(sqlite3 *dbInstance);

@interface CMS_Database : NSObject

+ (void)createCopyOfDatabaseIfNeeded;
+ (void)initializeDatabase;
+ (void)upgradeDatabaseIfRequired:(CMSDatabaseUpgradeBlock)upgradeBlock;
+ (NSString *)versionNumberString;

+ (void)add_table_field:(NSString *)tableName :(NSString *)fieldName;
+ (void)rename_table_field:(NSString *)tableName :(NSString *)oldFieldName :(NSString *)newFieldName;
+ (void)delete_table_field:(NSString *)tableName :(NSString *)fieldName;
+ (void)create_table:(NSString *)tableName :(NSArray *)fieldNames;
+ (void)drop_table_if_exists:(NSString *)tableName;
+ (BOOL)isTableExists:(NSString *)tableName;
+ (NSString *)db_escape_string:(NSString *)value;
+ (NSArray *)query:(NSString *)query;
+ (void)query_delete:(NSString *)tableName :(NSDictionary *)whereMap;
+ (void)query_insert:(NSString *)tableName :(NSDictionary *)valueMap;
+ (NSArray *)query_select:(NSString *)tableName :(NSArray *)selectList :(NSDictionary *)whereMap :(NSString *)extraSQL;
+ (NSString *)query_select_value:(NSString *)tableName :(NSString *)selectFieldName :(NSDictionary *)whereMap :(NSString *)extraSQL;
+ (int)query_select_int_value:(NSString *)tableName :(NSString *)selectFieldName :(NSDictionary *)whereMap :(NSString *)extraSQL;
+ (void)query_update:(NSString *)tableName :(NSDictionary *)valueMap :(NSDictionary *)whereMap;

+ (NSArray *) getFieldNamesForTable:(NSString *)tableName;

@end
