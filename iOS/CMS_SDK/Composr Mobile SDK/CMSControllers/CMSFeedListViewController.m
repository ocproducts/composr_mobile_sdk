//
//  CMSFeedListViewController.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 11/11/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMSFeedListViewController.h"
#import "CMSFeedDetailViewController.h"

#import "RSSParser.h"
#import "UIImageView+AFNetworking.h"

#define DEFAULT_FEED_URL @"http://ocportal.com/backend.php?type=RSS2&mode=news&days=300&max=100&keep_session=1245593369"

@implementation CMSFeedListViewController{
    NSString *feedUrl;
}

@synthesize dataSource;

- (id) initWithFeedUrl:(NSString *)url{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:CMS_STORYBOARD_NAME bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:STORYBOARD_ID_CMSFeedListViewController];
    if (self) {
        feedUrl = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Loading..."];
    
    if (!feedUrl) {
        feedUrl = DEFAULT_FEED_URL;
    }
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:feedUrl]];
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
        [self setTitle:@"Blog"];
        [self setDataSource:feedItems];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self setTitle:@"Error"];
        NSLog(@"Error: %@",error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSSItem *item = [dataSource objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.title];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.title];
    }
    
    // Configure the cell...
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [item title];
    
    if ([[item imagesFromItemDescription] count]>0) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:[item.imagesFromItemDescription objectAtIndex:0]]
                       placeholderImage:[UIImage imageNamed:nil]];
        
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:CMS_STORYBOARD_NAME bundle:nil];
    CMSFeedDetailViewController *detailView = [storyboard instantiateViewControllerWithIdentifier:STORYBOARD_ID_CMSFeedDetailViewController];
    detailView.feedItem = [dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
