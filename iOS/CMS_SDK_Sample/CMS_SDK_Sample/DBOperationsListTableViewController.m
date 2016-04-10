//
//  DBOperationsListTableViewController.m
//  CMS_SDK_Sample
//
//  Created by Aaswini on 01/03/15.
//  Copyright (c) 2015 Aaswini. All rights reserved.
//

#import "DBOperationsListTableViewController.h"
#import "CMS_Database.h"
#import "CreateTableViewController.h"
#import "AddTableRowViewController.h"
#import "ViewTableDataTableViewController.h"
#import "CMS_Strings.h"

@interface DBOperationsListTableViewController ()<UIAlertViewDelegate>{
    NSArray *operations;
}

@end

@implementation DBOperationsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CMS_Database initializeDatabase];
    
    operations = @[
                   @"Create Table",
                   @"Delete Table",
                   @"Add Table Row",
                   @"View Data"
                ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [operations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];
    
    [cell.textLabel setText:operations[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            [self createTable];
            break;
        }
            
        case 1:{
            [self deleteTable];
            break;
        }
            
        case 2:{
            [self addTableRow];
            break;
        }
            
        case 3:{
            [self viewData];
            break;
        }
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#define ALERT_CANCEL_TITLE @"Cancel"
#define ALERT_OK_TITLE @"Ok"

#define ALERT_CREATE_TABLE_TAG 1
#define ALERT_DELETE_TABLE_TAG 2
#define ALERT_INSERT_TABLE_TAG 3
#define ALERT_SELECT_TABLE_TAG 4

- (void)createTable {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Create Table" message:@"Enter table name :" delegate:self cancelButtonTitle:ALERT_CANCEL_TITLE otherButtonTitles:ALERT_OK_TITLE, nil];
    [alertView setTag:ALERT_CREATE_TABLE_TAG];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView setDelegate:self];
    [alertView show];
}

- (void)deleteTable {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete Table" message:@"Delete table name :" delegate:self cancelButtonTitle:ALERT_CANCEL_TITLE otherButtonTitles:ALERT_OK_TITLE, nil];
    [alertView setTag:ALERT_DELETE_TABLE_TAG];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView setDelegate:self];
    [alertView show];
}

- (void)addTableRow {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Table Row" message:@"Enter table name :" delegate:self cancelButtonTitle:ALERT_CANCEL_TITLE otherButtonTitles:ALERT_OK_TITLE, nil];
    [alertView setTag:ALERT_INSERT_TABLE_TAG];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView setDelegate:self];
    [alertView show];
}

- (void)viewData {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"View Table Data" message:@"Enter table name :" delegate:self cancelButtonTitle:ALERT_CANCEL_TITLE otherButtonTitles:ALERT_OK_TITLE, nil];
    [alertView setTag:ALERT_SELECT_TABLE_TAG];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView setDelegate:self];
    [alertView show];
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:ALERT_CANCEL_TITLE]) {
        return;
    }
    
    NSString *tableName = [alertView textFieldAtIndex:0].text;
    tableName = [CMS_Strings trim:tableName];
    tableName = [CMS_Strings str_replace:@" " :@"_" :tableName];
    
    switch (alertView.tag) {
        case ALERT_CREATE_TABLE_TAG:{
            if (![CMS_Database isTableExists:tableName]) {
                CreateTableViewController *createTableController = [[CreateTableViewController alloc] init];
                [createTableController setTableName:tableName];
                [self.navigationController pushViewController:createTableController animated:YES];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Table Already exists" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
            break;
        }
            
        case ALERT_DELETE_TABLE_TAG:{
            if ([CMS_Database isTableExists:tableName]) {
                [CMS_Database drop_table_if_exists:tableName];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Table Doesn't exist" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
            break;
        }
            
        case ALERT_INSERT_TABLE_TAG:{
            if ([CMS_Database isTableExists:tableName]) {
                AddTableRowViewController *addRowTableController = [[AddTableRowViewController alloc] init];
                [addRowTableController setTableName:tableName];
                [self.navigationController pushViewController:addRowTableController animated:YES];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Table Doesn't exist" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
            break;
        }
            
        case ALERT_SELECT_TABLE_TAG:{
            if ([CMS_Database isTableExists:tableName]) {
                ViewTableDataTableViewController *viewTableDataController = [self.storyboard instantiateViewControllerWithIdentifier:@"viewData"];
                [viewTableDataController setTableName:tableName];
                [self.navigationController pushViewController:viewTableDataController animated:YES];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Table Doesn't exist" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
            break;
        }
            
        default:
            break;
    }
}

@end
