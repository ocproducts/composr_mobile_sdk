//
//  CMSFeedDetailViewController.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 13/11/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMSFeedDetailViewController.h"
#import "CMS_Strings.h"
#import "UIImageView+AFNetworking.h"

@implementation CMSFeedDetailViewController

@synthesize feedItem, webViewFeedDescription ;
@synthesize lblSubmittedBy;

- (id) init{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:CMS_STORYBOARD_NAME bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:STORYBOARD_ID_CMSFeedDetailViewController];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.title = feedItem.title;
    [webViewFeedDescription loadHTMLString:feedItem.itemDescription baseURL:nil];
    lblSubmittedBy.text = [NSString stringWithFormat:@"Submitted by: %@, %@, %@", [CMS_Strings trim:feedItem.author], [CMS_Strings trim:feedItem.category], feedItem.pubDate];
    NSLog(@"%@",lblSubmittedBy.text);
    
    if (feedItem.enclosureUrl != nil && ![[CMS_Strings trim:feedItem.enclosureUrl] isEqualToString:@""]) {
        [self.imageView setImageWithURL:[NSURL URLWithString:feedItem.enclosureUrl] placeholderImage:[UIImage imageNamed:nil]];
    } else
        [self.imageView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark webviewdelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
@end
