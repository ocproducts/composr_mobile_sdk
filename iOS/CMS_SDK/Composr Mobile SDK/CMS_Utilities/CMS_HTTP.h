//
//  CMS_HTTP.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*
 
 CMS_HTTP
 
 string rawurlencode(string str) - see the PHP manual
 object json_decode(string value) - see the PHP manual
 string json_encode(object value) - see the PHP manual
 string get_base_url - gets base URL to ocPortal site, defined for the project in a string resource of constant
 string build_url(map params, string zone) - creates <base_url>/<zone>/index.php?<params...>
 string http_download_file(string url, bool triggerError, map postParams, int timeoutInSeconds) - if triggerError is true, a failure will show a generic error alert. If postParams is not null/nil then it will be an HTTP post.
 bool has_network_connection() - base the code on what we use for Fishin' Mobile, but make sure it is generic
 
 */

#import <Foundation/Foundation.h>

typedef void (^CMSCompletedDownloadBlock)(NSString *response);

@interface CMS_HTTP : NSObject

+ (NSString *)rawurlencode:(NSString *)str;
+ (id) json_decode:(NSString *)value;
+ (NSString *)json_encode:(id)value;
+ (NSString *)get_base_url;
+ (NSString *)build_url:(NSDictionary *)params :(NSString *)zone;
+ (void)http_download_file:(NSString *)url :(BOOL)triggerError :(NSDictionary *)postParams :(int)timeoutInSeconds :(CMSCompletedDownloadBlock)completionHandler;
+ (BOOL) has_network_connection;

@end
