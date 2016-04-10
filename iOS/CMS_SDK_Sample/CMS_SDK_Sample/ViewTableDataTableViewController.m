//
//  ViewTableDataTableViewController.m
//  CMS_SDK_Sample
//
//  Created by Aaswini on 01/03/15.
//  Copyright (c) 2015 Aaswini. All rights reserved.
//

#import "ViewTableDataTableViewController.h"
#import "CMS_Database.h"
#import "CMS_Arrays.h"

@interface ViewTableDataTableViewController (){
    NSArray *data;
}

@end

@implementation ViewTableDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data = [CMS_Database query_select:self.tableName :@[@"*"] :nil :nil];
    [self setTitle:self.tableName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Data at index : %d",(int)indexPath.row] message:[CMS_Arrays implode:@", " :[data[indexPath.row] allValues]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

@end
