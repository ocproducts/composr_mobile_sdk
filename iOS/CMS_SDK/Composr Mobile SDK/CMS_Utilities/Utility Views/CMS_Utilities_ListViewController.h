//
//  CMS_Utilities_ListViewController.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 22/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMS_Utility_ListViewController_Delegate <NSObject>

@optional
- (void) didSelectOption:(NSString *)option;
@end

@interface CMS_Utilities_ListViewController : UIViewController
@property NSArray *options;
@property id<CMS_Utility_ListViewController_Delegate> delegate;

@end
