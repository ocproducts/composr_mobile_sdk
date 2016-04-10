//
//  CMS_HTTP.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMS_HTTP.h"
#import "AFHTTPRequestOperationManager.h"

@implementation CMS_HTTP

/**
 *  URL-encode according to RFC 3986
 *
 *  @param str The URL to be encoded.
 *
 *  @return Returns a string in which all non-alphanumeric characters except -_.~ have been replaced with a percent (%) sign followed by two hex digits. This is the encoding described in » RFC 3986 for protecting literal characters from being interpreted as special URL delimiters, and for protecting URLs from being mangled by transmission media with character conversions (like some email systems).
 */
+ (NSString *)rawurlencode:(NSString *)str{
    return [str urlEncodedString];
}

/**
 *  Takes a JSON encoded string and converts it into a PHP variable
 *
 *  @param value The json string being decoded
 *
 *  @return Returns the value encoded in json
 */
+ (id) json_decode:(NSString *)value{
    return [value objectFromJSONString];
}

/**
 *  Returns a string containing the JSON representation of value.
 *
 *  @param value The value being encoded.
 *
 *  @return Returns a JSON encoded string on success
 */
+ (NSString *)json_encode:(id)value{
    return [value JSONString];
}

/**
 *  Returns the base url used by web services in the app
 *
 *  @return Returns the base url used by web services in the app as String
 */
+ (NSString *)get_base_url{
    return k_WEBSERVICES_DOMAIN;
}

/**
 *  creates <base_url>/<zone>/index.php?<params...>
 *
 *  @param params parameters to be appended to url
 *  @param zone   zone to be used
 *
 *  @return built url from zone and parameter values
 */
+ (NSString *)build_url:(NSDictionary *)params :(NSString *)zone{
    NSMutableString *url = [@"" mutableCopy];
    [url appendString:k_WEBSERVICES_DOMAIN];
    [url appendFormat:@"/%@/index.php?",zone];
    for (NSString *key in params.allKeys) {
        [url appendFormat:@"&%@=%@",key,[params objectForKey:key]];
    }
    return url;
}

/**
 *  Downloads string contents from a url
 *
 *  @param url              url
 *  @param triggerError     to show error or not
 *  @param postParams       post parameters
 *  @param timeoutInSeconds timeout for the request
 *
 *  @return returns the response for the url request
 */
+ (void)http_download_file:(NSString *)url :(BOOL)triggerError :(NSDictionary *)postParams :(int)timeoutInSeconds :(CMSCompletedDownloadBlock)completionHandler{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url
       parameters:postParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              completionHandler(operation.responseString);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error && triggerError) {
                  [UIAlertView showWithError:error];
              }
          }
     ];
}

/**
 *  Returns status of internet connection
 *
 *  @return YES if connected. NO otherwise.
 */
+ (BOOL) has_network_connection{
    if ([[[NSProcessInfo processInfo] arguments] indexOfObject:@"work_offline"] != NSNotFound)
        return FALSE;
    
    Reachability *connectionMonitor = [Reachability reachabilityForInternetConnection];
    return ([connectionMonitor currentReachabilityStatus] != NotReachable);
}
@end
