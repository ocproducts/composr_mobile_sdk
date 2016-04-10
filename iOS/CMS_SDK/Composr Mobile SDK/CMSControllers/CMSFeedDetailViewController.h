//
//  CMSFeedDetailViewController.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 13/11/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RSSParser.h"

#define STORYBOARD_ID_CMSFeedDetailViewController @"CMSFeedDetailViewController"

@interface CMSFeedDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webViewFeedDescription;
@property (weak,nonatomic) RSSItem *feedItem;
@property (weak, nonatomic) IBOutlet UILabel *lblSubmittedBy;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end
