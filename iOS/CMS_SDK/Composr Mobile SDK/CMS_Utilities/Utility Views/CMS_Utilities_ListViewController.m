//
//  CMS_Utilities_ListViewController.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 22/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMS_Utilities_ListViewController.h"

@interface CMS_Utilities_ListViewController ()

@end

@implementation CMS_Utilities_ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (self.options == nil) {
        self.options = @[@"No options to select"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark Table view datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    cell.textLabel.text = self.options[indexPath.row];
    
    return cell;
}

#pragma mark --------------

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(didSelectOption:)]) {
            [self.delegate didSelectOption:self.options[indexPath.row]];
        }
    }
}

#pragma mark --------------

@end
