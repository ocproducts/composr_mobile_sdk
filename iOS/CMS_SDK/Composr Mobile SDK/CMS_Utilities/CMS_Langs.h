//
//  CMS_Langs.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*

 CMS_Langs
 
 string do_lang(string strName, array parameters) -- lookup a translation string, with a list of parameters for it
 
 */

#import <Foundation/Foundation.h>

@interface CMS_Langs : NSObject

+ (NSString *)do_lang:(NSString *)key ;
+ (NSString *)do_lang:(NSString *)strName :(NSArray *)parameters;

@end
