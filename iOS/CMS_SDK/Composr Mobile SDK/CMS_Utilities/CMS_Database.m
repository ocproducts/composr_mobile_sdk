//
//  CMS_Database.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMS_Database.h"
#import "CMS_Arrays.h"
#import "CMS_Strings.h"

#define k_DBVERSION @"db_version"

static sqlite3 *objDBHandler = nil;

@implementation CMS_Database

/**
 *  Copy database file from the bundle to documents directory if DB doesn't exist.
 */
+ (void)createCopyOfDatabaseIfNeeded{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"cms_DB.sqlite"];
    
    // First, test for existence.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([[[NSProcessInfo processInfo] arguments] indexOfObject:@"database_reset"] != NSNotFound) {
        [fileManager removeItemAtPath:writableDBPath error:nil];
    }
    if ([fileManager fileExistsAtPath:writableDBPath]) return;
    
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cms_DB.sqlite"];
    NSError *error;
    BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

/**
 *  Opens the db from the documents directory. Performs any upgrades if needed and keeps the db ready to work.
 */
+ (void)initializeDatabase{
    // The database is stored in the application bundle.
    
    // Open the database. The database was prepared outside the application.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"cms_DB.sqlite"];
    
    NSLog(@"DB Path = %@", writableDBPath);
    
    if (sqlite3_open([writableDBPath UTF8String], &objDBHandler) == SQLITE_OK) {
        NSLog(@"Database connection open successfully");
        //        [self upgradeDatabaseIfRequired:nil];
    } else
    {
        sqlite3_close(objDBHandler);
    }
}

/**
 *  Upgrade db if new version of app is released.
 */
+ (void)upgradeDatabaseIfRequired:(CMSDatabaseUpgradeBlock)upgradeBlock{
    if (upgradeBlock) {
        upgradeBlock(objDBHandler);
    }
    else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *previousVersion = [defaults objectForKey:k_DBVERSION];
        NSString *currentVersion = [self versionNumberString];
        
        if (previousVersion==nil){
            // do nothing. first install.
        }
        else if([previousVersion compare:currentVersion options:NSNumericSearch] == NSOrderedAscending) {
            // previous < current
            // place upgrade codes here for each versions in their corresponding if structures.
            // You can use the "objDBHandler" variable to access the db.
            
            int prevVersion = [previousVersion intValue];
            
            if (prevVersion < 1) {
                // place all codes for upgradation to version 1
                
                prevVersion = 1;
            }
            
            if (prevVersion < 2){
                // place all codes for upgradation to version 2
                
                prevVersion = 2;
            }
        }
        
        [defaults setObject:currentVersion forKey:k_DBVERSION];
        [defaults synchronize];
    }
}

/**
 *  Returns the version of the app
 *
 *  @return NSString version of the app from info.plist
 */
+ (NSString *)versionNumberString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return majorVersion;
}

/**
 *  Add a new column to a table in db
 *
 *  @param tableName table name
 *  @param fieldName new field name
 */
+ (void) add_table_field:(NSString *)tableName :(NSString *)fieldName{
    
    NSString *sqlTmp = [[NSString alloc]initWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ TEXT;", tableName, fieldName];
    const char *sqlStmt = [sqlTmp UTF8String];
    sqlite3_stmt *cmp_sqlStmt;
    int returnValue = sqlite3_prepare_v2(objDBHandler, sqlStmt, -1, &cmp_sqlStmt, NULL);
    if (returnValue == SQLITE_OK) {
        if (sqlite3_step(cmp_sqlStmt) == SQLITE_DONE) {
            NSLog(@"Added new field");
        }
    } else
    {
        NSLog(@"Error in adding field: %@", @(sqlite3_errmsg(objDBHandler)));
    }
    
    sqlite3_finalize(cmp_sqlStmt);
}

/**
 *  Rename a column in the db
 *
 *  @param tableName    table name
 *  @param oldFieldName old column name
 *  @param newFieldName new column name
 */
+ (void) rename_table_field:(NSString *)tableName :(NSString *)oldFieldName :(NSString *)newFieldName{
    NSArray *fieldNames = [self getFieldNamesForTable:tableName];
    NSMutableArray *newFieldNames = [NSMutableArray new];
    for (NSString *val in fieldNames) {
        if ([val isEqualToString:oldFieldName]) {
            [newFieldNames addObject:newFieldName];
        }
        else{
            [newFieldNames addObject:val];
        }
    }
    
    NSArray *data = [self query_select:tableName :@[@""] :@{} :@""];
    
    [self drop_table_if_exists:tableName];
    [self create_table:tableName :newFieldNames];
    for (NSDictionary *dict in data) {
        [self query_insert:tableName :dict];
    }
    
}

/**
 *  Delete a column from the db
 *
 *  @param tableName table name
 *  @param fieldName column name to delete
 *
 *  Warning : Data in the column will be truncated
 */
+ (void) delete_table_field:(NSString *)tableName :(NSString *)fieldName{
    NSArray *fieldNames = [self getFieldNamesForTable:tableName];
    NSMutableArray *newFieldNames = [NSMutableArray new];
    for (NSString *val in fieldNames) {
        if (![val isEqualToString:fieldName]) {
            [newFieldNames addObject:val];
        }
    }
    
    NSArray *data = [self query_select:tableName :@[@""] :@{} :@""];
    
    NSMutableArray *newData = [NSMutableArray new];
    for (NSDictionary *dict in data) {
        NSMutableDictionary *newDict = [NSMutableDictionary new];
        for (NSString *key in dict.allKeys) {
            if (![key isEqualToString:fieldName]) {
                [newDict setObject:[dict objectForKey:key] forKey:key];
            }
        }
    }
    [self drop_table_if_exists:tableName];
    [self create_table:tableName :newFieldNames];
    for (NSDictionary *dict in newData) {
        [self query_insert:tableName :dict];
    }
}

/**
 *  Create a new table with columns. All columns will be created with TEXT as type
 *
 *  @param tableName  table name
 *  @param fieldNames columns in the table
 */
+ (void) create_table:(NSString *)tableName :(NSArray *)fieldNames{
    
    NSString *createQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(", tableName ];
    for (int i=0; i<fieldNames.count; i++) {
        createQuery = [createQuery stringByAppendingString:@"%@ TEXT"];
        if (i != fieldNames.count-1) {
            createQuery = [createQuery stringByAppendingString:@" ,"];
        }
    }
    createQuery = [createQuery stringByAppendingString:@");"];
    
    NSString *sqlTmp = [CMS_Strings stringWithFormat:createQuery array:fieldNames];
    const char *sqlStmt = [sqlTmp UTF8String];
    int returnValue = sqlite3_exec(objDBHandler, sqlStmt, NULL, NULL, NULL);
    if (returnValue == SQLITE_OK) {
        NSLog(@"Created new table");
    } else
    {
        NSLog(@"Error in creating table: %@", @(sqlite3_errmsg(objDBHandler)));
    }
}

/**
 *  Deletes a table if exists
 *
 *  @param tableName table name to delete
 */
+ (void) drop_table_if_exists:(NSString *)tableName{
    NSString *sqlTmp = [[NSString alloc]initWithFormat:@"DROP TABLE IF EXISTS %@;", tableName];
    const char *sqlStmt = [sqlTmp UTF8String];
    int returnValue = sqlite3_exec(objDBHandler, sqlStmt, NULL, NULL, NULL);
    if (returnValue == SQLITE_OK) {
        NSLog(@"Deleted table");
    } else
    {
        NSLog(@"Error in deleting table: %@", @(sqlite3_errmsg(objDBHandler)));
    }
}

/**
 *  Checks if a table exists in the database with table name
 *
 *  @param tableName table name to check
 *
 *  @return YES if table exists else NO
 */
+ (BOOL)isTableExists:(NSString *)tableName {
    if (!tableName || [tableName isEqualToString:@""]) {
        return NO;
    }
    NSString *query = [NSString stringWithFormat:@"SELECT DISTINCT tbl_name FROM sqlite_master WHERE tbl_name = '%@'", tableName];
    const char *sqlStmt = [query UTF8String];
    sqlite3_stmt *cmp_sqlStmt;
    int returnValue = sqlite3_prepare_v2(objDBHandler, sqlStmt, -1, &cmp_sqlStmt, NULL);
    if (returnValue == SQLITE_OK) {
        if (sqlite3_step(cmp_sqlStmt) == SQLITE_ROW) {
            NSString *value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(cmp_sqlStmt, 0)];
            if ([value isEqualToString:tableName]) {
                sqlite3_finalize(cmp_sqlStmt);
                return YES;
            }
        }
    } else
    {
        NSLog(@"Error in selecting value: %@", @(sqlite3_errmsg(objDBHandler)));
    }
    
    sqlite3_finalize(cmp_sqlStmt);
    
    return NO;
}

/**
 *  Escapes an string to suite to sqlite query format.
 *  Currently, only escapes single quotes.
 *
 *  @param value string to be escaped
 *
 *  @return escaped string
 */
+ (NSString *) db_escape_string:(NSString *)value{
    return [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

/**
 *  Execute a query and return the result set
 *
 *  @param query query to be executed
 *
 *  @return Array of dictionaries. Each dictionary corresponds to each row in the resultant table.
 */
+ (NSArray *) query:(NSString *)query{
    const char *sqlStmt = [query UTF8String];
    sqlite3_stmt *cmp_sqlStmt;
    int returnValue = sqlite3_prepare_v2(objDBHandler, sqlStmt, -1, &cmp_sqlStmt, NULL);
    if (returnValue == SQLITE_OK) {
        NSMutableArray *result = [NSMutableArray new];
        while (sqlite3_step(cmp_sqlStmt) == SQLITE_ROW) {
            NSMutableDictionary *row = [NSMutableDictionary new];
            int numberOfColumns = sqlite3_data_count(cmp_sqlStmt);
            for (int i=0; i<numberOfColumns; i++) {
                NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(cmp_sqlStmt, i)];
                NSString *value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(cmp_sqlStmt, i)];
                [row setObject:value forKey:columnName];
            }
            [result addObject:row];
        }
        return result;
    } else
    {
        NSLog(@"Error in selecting rows: %@", @(sqlite3_errmsg(objDBHandler)));
    }
    
    sqlite3_finalize(cmp_sqlStmt);
    
    return @[];
}

/**
 *  Delete a value from table with condition
 *
 *  @param tableName table name
 *  @param whereMap  condition
 */
+ (void) query_delete:(NSString *)tableName :(NSDictionary *)whereMap{
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ", tableName ];
    deleteQuery = [deleteQuery stringByAppendingString:[CMS_Database convertWhereMapToSQL:whereMap :@"AND"]];
    deleteQuery = [deleteQuery stringByAppendingString:@" ;"];
    
    NSString *sqlTmp = deleteQuery;
    const char *sqlStmt = [sqlTmp UTF8String];
    int returnValue = sqlite3_exec(objDBHandler, sqlStmt, NULL, NULL, NULL);
    if (returnValue == SQLITE_OK) {
        NSLog(@"Deleted row");
    } else
    {
        NSLog(@"Error in deleting row: %@", @(sqlite3_errmsg(objDBHandler)));
    }
}

/**
 *  Insert single record into table
 *
 *  @param tableName table name
 *  @param valueMap  record as a dictionary with column name mapped to value
 */
+ (void) query_insert:(NSString *)tableName :(NSDictionary *)valueMap{
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO %@ ",tableName];
    insertQuery = [insertQuery stringByAppendingString:[self convertValueMapToInsertSQL:valueMap]];
    insertQuery = [insertQuery stringByAppendingString:@" ;"];
    
    NSString *sqlTmp = insertQuery;
    const char *sqlStmt = [sqlTmp UTF8String];
    int returnValue = sqlite3_exec(objDBHandler, sqlStmt, NULL, NULL, NULL);
    if (returnValue == SQLITE_OK) {
        NSLog(@"Inserted row");
    } else
    {
        NSLog(@"Error in inserting row: %@", @(sqlite3_errmsg(objDBHandler)));
    }
}

/**
 *  Select query
 *
 *  @param tableName  table name
 *  @param selectList list of columns to be selected
 *  @param whereMap   where conditions
 *  @param extraSQL   any extra sql codes
 *
 *  @return returns the result set as an array of dictionaries. Each dictionary corresponds to each row in the resultant table.
 */
+ (NSArray *)query_select:(NSString *)tableName :(NSArray *)selectList :(NSDictionary *)whereMap :(NSString *)extraSQL{
    NSString *selectQuery;
    if (whereMap) {
        selectQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ ",
                       [CMS_Arrays implode:@"," :selectList],
                       tableName,
                       [self convertWhereMapToSQL:whereMap :@"AND"]
                       ];
    }
    else {
        selectQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ ;",
                       [CMS_Arrays implode:@"," :selectList],
                       tableName
                       ];
    }
    if (extraSQL != nil) {
        selectQuery = [selectQuery stringByAppendingString:extraSQL];
    }
    selectQuery = [selectQuery stringByAppendingString:@" ;"];
    
    NSString *sqlTmp = selectQuery;
    const char *sqlStmt = [sqlTmp UTF8String];
    sqlite3_stmt *cmp_sqlStmt;
    int returnValue = sqlite3_prepare_v2(objDBHandler, sqlStmt, -1, &cmp_sqlStmt, NULL);
    if (returnValue == SQLITE_OK) {
        NSMutableArray *result = [NSMutableArray new];
        while (sqlite3_step(cmp_sqlStmt) == SQLITE_ROW) {
            NSMutableDictionary *row = [NSMutableDictionary new];
            int numberOfColumns = sqlite3_data_count(cmp_sqlStmt);
            for (int i=0; i<numberOfColumns; i++) {
                NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(cmp_sqlStmt, i)];
                NSString *value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(cmp_sqlStmt, i)];
                [row setObject:value forKey:columnName];
            }
            [result addObject:row];
        }
        return result;
    } else
    {
        NSLog(@"Error in selecting rows: %@", @(sqlite3_errmsg(objDBHandler)));
    }
    
    sqlite3_finalize(cmp_sqlStmt);
    return @[];
}

/**
 *  Select single string from a table.
 *
 *  @param tableName       table name
 *  @param selectFieldName column name to select
 *  @param whereMap        where condition
 *  @param extraSQL        any extra sql codes if required
 *
 *  @return returns resultant single value as a string
 */
+ (NSString *)query_select_value:(NSString *)tableName :(NSString *)selectFieldName :(NSDictionary *)whereMap :(NSString *)extraSQL{
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ ",
                             selectFieldName,
                             tableName,
                             [self convertWhereMapToSQL:whereMap :@"AND"]
                             ];
    if (extraSQL != nil) {
        selectQuery = [selectQuery stringByAppendingString:extraSQL];
    }
    selectQuery = [selectQuery stringByAppendingString:@" ;"];
    
    NSString *sqlTmp = selectQuery;
    const char *sqlStmt = [sqlTmp UTF8String];
    sqlite3_stmt *cmp_sqlStmt;
    int returnValue = sqlite3_prepare_v2(objDBHandler, sqlStmt, -1, &cmp_sqlStmt, NULL);
    if (returnValue == SQLITE_OK) {
        if (sqlite3_step(cmp_sqlStmt) == SQLITE_ROW) {
            NSString *value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(cmp_sqlStmt, 0)];
            sqlite3_finalize(cmp_sqlStmt);
            return value;
        }
    } else
    {
        NSLog(@"Error in selecting value: %@", @(sqlite3_errmsg(objDBHandler)));
    }
    
    sqlite3_finalize(cmp_sqlStmt);
    
    return @"";
}

/**
 *  Select single integer value from a table.
 *
 *  @param tableName       table name
 *  @param selectFieldName column name to select
 *  @param whereMap        where condition
 *  @param extraSQL        any extra sql codes if required
 *
 *  @return returns resultant single value as an int. -1 if none found.
 */
+ (int)query_select_int_value:(NSString *)tableName :(NSString *)selectFieldName :(NSDictionary *)whereMap :(NSString *)extraSQL{
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ ",
                             selectFieldName,
                             tableName,
                             [self convertWhereMapToSQL:whereMap :@"AND"]
                             ];
    if (extraSQL != nil) {
        selectQuery = [selectQuery stringByAppendingString:extraSQL];
    }
    selectQuery = [selectQuery stringByAppendingString:@" ;"];
    
    NSString *sqlTmp = selectQuery;
    const char *sqlStmt = [sqlTmp UTF8String];
    sqlite3_stmt *cmp_sqlStmt;
    int returnValue = sqlite3_prepare_v2(objDBHandler, sqlStmt, -1, &cmp_sqlStmt, NULL);
    if (returnValue == SQLITE_OK) {
        if (sqlite3_step(cmp_sqlStmt) == SQLITE_ROW) {
            int value = sqlite3_column_int(cmp_sqlStmt, 0);
            sqlite3_finalize(cmp_sqlStmt);
            return value;
        }
    } else
    {
        NSLog(@"Error in selecting value: %@", @(sqlite3_errmsg(objDBHandler)));
    }
    
    sqlite3_finalize(cmp_sqlStmt);
    
    return -1;
}

/**
 *  Simple update query
 *
 *  @param tableName table name
 *  @param valueMap  dictionary of values to be updated with keys as column name
 *  @param whereMap  where condition
 */
+ (void)query_update:(NSString *)tableName :(NSDictionary *)valueMap :(NSDictionary *)whereMap{
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ ",
                             tableName,
                             [self convertWhereMapToSQL:valueMap :@","],
                             [self convertWhereMapToSQL:whereMap :@"AND"]
                             ];
    updateQuery = [updateQuery stringByAppendingString:@" ;"];
    
    NSString *sqlTmp = updateQuery;
    const char *sqlStmt = [sqlTmp UTF8String];
    int returnValue = sqlite3_exec(objDBHandler, sqlStmt, NULL, NULL, NULL);
    if (returnValue == SQLITE_OK) {
        NSLog(@"Updated row");
    } else
    {
        NSLog(@"Error in updating row: %@", @(sqlite3_errmsg(objDBHandler)));
    }
}

/**
 *  Column names in a table
 *
 *  @param tableName table name
 *
 *  @return list of names of columns in a table
 */
+ (NSArray *) getFieldNamesForTable:(NSString *)tableName{
    NSString *fieldsQuery = [NSString stringWithFormat:@"PRAGMA table_info(%@);", tableName];
    
    const char *sqlStmt = [fieldsQuery UTF8String];
    sqlite3_stmt *cmp_sqlStmt;
    int returnValue = sqlite3_prepare_v2(objDBHandler, sqlStmt, -1, &cmp_sqlStmt, NULL);
    if (returnValue == SQLITE_OK) {
        NSMutableArray *result = [NSMutableArray new];
        while (sqlite3_step(cmp_sqlStmt) == SQLITE_ROW) {
            NSString *value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(cmp_sqlStmt, 1)];
            [result addObject:value];
        }
        return result;
    } else
    {
        NSLog(@"Error in selecting rows: %@", @(sqlite3_errmsg(objDBHandler)));
    }
    
    sqlite3_finalize(cmp_sqlStmt);
    
    return @[];
}

// converts where map in the format - key1='value1', key2='value2', ...
+ (NSString *) convertWhereMapToSQL:(NSDictionary *)whereMap :(NSString *)conjuction{
    NSString *whereSQL = @"";
    for (int i=0; i<whereMap.allKeys.count; i++) {
        whereSQL = [whereSQL stringByAppendingString:[NSString stringWithFormat:@"%@ = ", whereMap.allKeys[i]]];
        whereSQL = [whereSQL stringByAppendingString:@"'%@'"];
        if (i != whereMap.allKeys.count-1) {
            whereSQL = [whereSQL stringByAppendingFormat:@" %@ ",conjuction];
        }
    }
    
    return [CMS_Strings stringWithFormat:whereSQL array:[CMS_Arrays Array_values:NO :whereMap]];
}

// converts value map in the format - (key1 , key2, key3, ..) VALUES ('value1', 'value2', 'value3', ...)
+ (NSString *) convertValueMapToInsertSQL:(NSDictionary *)valueMap{
    NSMutableString *insertSQL = [[NSMutableString alloc] initWithCapacity:10];
    [insertSQL appendString:@"("];
    
    NSArray *keys = [valueMap allKeys];
    for (int i=0; i<keys.count; i++) {
        [insertSQL appendFormat:@"%@",keys[i]];
        if (i != keys.count-1) {
            [insertSQL appendString:@", "];
        }
    }
    
    [insertSQL appendString:@") VALUES ("];
    
    for (int i=0; i<keys.count; i++) {
        [insertSQL appendFormat:@"'%@'",[valueMap objectForKey:keys[i]]];
        if (i != keys.count-1) {
            [insertSQL appendString:@", "];
        }
    }
    
    [insertSQL appendString:@")"];
    
    return insertSQL;
}

@end
