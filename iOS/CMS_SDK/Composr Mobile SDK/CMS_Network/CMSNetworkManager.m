//
//  CMSNetworkManager.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 03/09/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "CMSNetworkManager.h"
#import "CMS_HTTP.h"
#import "CMS_Users.h"
#import "CMS_Preferences.h"
#import "AppDelegate.h"

@implementation CMSNetworkManager{
    MBProgressHUD *progressLoader;
}

+ (BOOL)isResponseValid:(NSDictionary *)response{
    if ([response objectForKey:@"success"] != nil && [[NSString stringWithFormat:@"%@",[response objectForKey:@"success"]] isEqualToString:@"1"]){
        return YES;
    }
    return NO;
}

+ (id)getResponseData:(NSDictionary *)response{
    if ([response objectForKey:@"success"] != nil && [[NSString stringWithFormat:@"%@",[response objectForKey:@"success"]] isEqualToString:@"1"]){
        return response[@"response_data"];
    }
    return @{};
}

+ (NSError *)getError:(NSDictionary *)response{
    if ([response objectForKey:@"success"]!=nil && ![[NSString stringWithFormat:@"%@",[response objectForKey:@"success"]] isEqualToString:@"1"]) {
        if ([response objectForKey:@"error_details"]!=nil && [[response objectForKey:@"error_details"] isKindOfClass:[NSString class]]) {
            NSError *error = [NSError errorWithDomain:[response objectForKey:@"error_details"] code:300 userInfo:response];
            
            return error;
        }
        else{
            NSError *error = [NSError errorWithDomain:@"Sorry. Something went wrong." code:300 userInfo:response];
            return error;
        }
    }
    
    NSError *error = [NSError errorWithDomain:@"Sorry. Something went wrong." code:300 userInfo:response];
    return error;
}

+ (CMSNetworkManager *)sharedManagerWithUrl:(NSString *)url
{
    static CMSNetworkManager *_sharedManager = nil;
    static NSString *baseUrl;
    
    if (url) {
        baseUrl = url;
    } else if(!baseUrl) {
        baseUrl = [CMS_HTTP get_base_url];
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    });
    
    return _sharedManager;
}

+ (CMSNetworkManager *)sharedManager
{
    return [CMSNetworkManager sharedManagerWithUrl:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.requestSerializer setAuthorizationHeaderFieldWithUsername:[CMS_Users get_username] password:[CMS_Users get_password]];
    }
    
    return self;
}

- (void)setHeaders{
    [self.requestSerializer setValue:[CMS_Users get_value:kHTTPHeader_MemberID_CookieValue] forHTTPHeaderField:[CMS_Users get_value:kHTTPHeader_MemberID_CookieName]];
    [self.requestSerializer setValue:[CMS_Users get_value:kHTTPHeader_MemberID_Hashed_CookieValue] forHTTPHeaderField:[CMS_Users get_value:kHTTPHeader_MemberID_Hashed_CookieName]];
}

- (void)clearHeaders{
    [self.requestSerializer setValue:nil forHTTPHeaderField:[CMS_Users get_value:kHTTPHeader_MemberID_CookieName]];
    [self.requestSerializer setValue:nil forHTTPHeaderField:[CMS_Users get_value:kHTTPHeader_MemberID_Hashed_CookieName]];
}

- (void)executePOSTWithParams:(NSDictionary *)params forURL:(NSString *)url onCompletion:(CMSResponseBlock)objectBlock onFaillure:(CMSErrorBlock)failBlock showLoader:(BOOL)showLoader{
    
    if (showLoader) {
        [MBProgressHUD showGlobalProgressHUD];
    }
    
    [self POST:url parameters:params constructingBodyWithBlock:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           objectBlock(responseObject);
           [MBProgressHUD dismissGlobalHUD];
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           failBlock(error);
           [MBProgressHUD dismissGlobalHUD];
       }
     ];
}

- (void)executeGETWithParams:(NSDictionary *)params forURL:(NSString *)url onCompletion:(CMSResponseBlock)objectBlock onFaillure:(CMSErrorBlock)failBlock showLoader:(BOOL)showLoader{
    
    if (showLoader) {
        [MBProgressHUD showGlobalProgressHUD];
    }
    
    [self GET:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          objectBlock(responseObject);
          [MBProgressHUD dismissGlobalHUD];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          failBlock(error);
          [MBProgressHUD dismissGlobalHUD];
      }
     ];
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
             onCompletion:(CMSResponseBlock)objectBlock
               onFaillure:(CMSErrorBlock)failBlock
               showLoader:(BOOL)showLoader{
    
    NSDictionary *params = @{
                             URL_LOGIN_PARAM_username: (username == nil) ? @"": username,
                             URL_LOGIN_PARAM_password: (password == nil) ? @"": password
                             };
    
    [self executePOSTWithParams:params
                         forURL:URL_LOGIN
                   onCompletion:^(NSDictionary *response) {
                       
                       NSLog(@"Login API Response ---> %@",response);
                       
                       if ([CMSNetworkManager isResponseValid:response]) {
                           NSDictionary *responseData = [CMSNetworkManager getResponseData:response];
                           if (responseData) {
                               NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                               
                               //setting member_id and cookie values
                               [userDefaults setValue:params[URL_LOGIN_PARAM_username] forKey:k_Username];
                               [userDefaults setValue:params[URL_LOGIN_PARAM_password] forKey:k_Password];
                               [userDefaults setValue:responseData[kHTTPHeader_MemberID_Hashed_CookieName] forKey:kHTTPHeader_MemberID_Hashed_CookieName];
                               [userDefaults setValue:responseData[kHTTPHeader_MemberID_Hashed_CookieValue] forKey:kHTTPHeader_MemberID_Hashed_CookieValue];
                               [userDefaults setValue:responseData[kHTTPHeader_MemberID_CookieName] forKey:kHTTPHeader_MemberID_CookieName];
                               [userDefaults setValue:responseData[kHTTPHeader_MemberID_CookieValue] forKey:kHTTPHeader_MemberID_CookieValue];
                               [userDefaults setValue:responseData[kHTTPHeader_MemberID_CookieValue] forKey:k_MemberID];
                               
                               NSDictionary *userData = responseData[@"user_data"];
                               for (NSString *key in userData.allKeys) {
                                   [userDefaults setObject:userData[key] forKey:key];
                               }
                               
                               //set username and password
                               [userDefaults setValue:params[URL_LOGIN_PARAM_username] forKey:k_Username];
                               [userDefaults setValue:params[URL_LOGIN_PARAM_password] forKey:k_Password];
                               
                               [userDefaults synchronize];
                               
                               [self setHeaders];
                           }
                           
                           if (objectBlock != nil) {
                               objectBlock(responseData);
                           }
                           else if (self.loginDelegate != nil && [self.loginDelegate respondsToSelector:@selector(CMSNetworkManager:didLoginWithResponse:)]) {
                               [self.loginDelegate CMSNetworkManager:self didLoginWithResponse:responseData];
                           }
                       }
                       else{
                           NSError *error = [CMSNetworkManager getError:response];
                           if (failBlock != nil) {
                               failBlock(error);
                           }
                           else if (self.loginDelegate != nil && [self.loginDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToLoginWithError:)]) {
                               [self.loginDelegate CMSNetworkManager:self didFailToLoginWithError:error];
                           }
                       }
                   }
                     onFaillure:^(NSError *error) {
                         
                         if (failBlock != nil) {
                             failBlock(error);
                         }
                         else if (self.loginDelegate != nil && [self.loginDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToLoginWithError:)]) {
                             [self.loginDelegate CMSNetworkManager:self didFailToLoginWithError:error];
                         }
                     }
                     showLoader:showLoader
     ];
}

- (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
             confirmPassword:(NSString *)confirmPassword
                       email:(NSString *)email
                confirmEmail:(NSString *)confirmEmail
                     dob_day:(NSString *)dob_day
                   dob_month:(NSString *)dob_month
                    dob_year:(NSString *)dob_year
                    timezone:(NSString *)timeZone
                onCompletion:(CMSResponseBlock)objectBlock
                  onFaillure:(CMSErrorBlock)failBlock
                  showLoader:(BOOL)showLoader{
    
    NSDictionary *params = @{
                             URL_REGISTER_PARAM_username: (username == nil) ? @"": username,
                             URL_REGISTER_PARAM_password: (password == nil) ? @"": password,
                             URL_REGISTER_PARAM_confirm_password: (confirmPassword == nil) ? @"": confirmPassword,
                             URL_REGISTER_PARAM_email: (email == nil) ? @"": email,
                             URL_REGISTER_PARAM_confirm_email: (confirmEmail == nil) ? @"": confirmEmail,
                             URL_REGISTER_PARAM_DOB_day: (dob_day == nil) ? @"": dob_day,
                             URL_REGISTER_PARAM_DOB_month: (dob_month == nil) ? @"": dob_month,
                             URL_REGISTER_PARAM_DOB_year: (dob_year == nil) ? @"": dob_year,
                             URL_REGISTER_PARAM_timezone: (timeZone == nil)? @"": timeZone
                             };
    
    [self executePOSTWithParams:params
                         forURL:URL_REGISTER
                   onCompletion:^(NSDictionary *response) {
                       
                       if ([CMSNetworkManager isResponseValid:response]) {
                           if (objectBlock != nil) {
                               objectBlock(response);
                           }
                           else if (self.registerDelegate != nil && [self.registerDelegate respondsToSelector:@selector(CMSNetworkManager:didRegisterWithResponse:)]) {
                               [self.registerDelegate CMSNetworkManager:self didRegisterWithResponse:response];
                           }
                       }
                       else{
                           NSError *error = [CMSNetworkManager getError:response];
                           if (failBlock != nil) {
                               failBlock(error);
                           }
                           else if (self.registerDelegate != nil && [self.registerDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToRegisterWithError:)]) {
                               [self.registerDelegate CMSNetworkManager:self didFailToRegisterWithError:error];
                           }
                       }
                       
                   }
                     onFaillure:^(NSError *error) {
                         
                         if (failBlock != nil) {
                             failBlock(error);
                         }
                         else if (self.registerDelegate != nil && [self.registerDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToRegisterWithError:)]) {
                             [self.registerDelegate CMSNetworkManager:self didFailToRegisterWithError:error];
                         }
                     }
                     showLoader:showLoader
     ];
}

- (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
                       email:(NSString *)email
                    timezone:(NSString *)timeZone
                onCompletion:(CMSResponseBlock)objectBlock
                  onFaillure:(CMSErrorBlock)failBlock
                  showLoader:(BOOL)showLoader{
    
    NSDictionary *params = @{
                             URL_REGISTER_PARAM_username: (username == nil) ? @"": username,
                             URL_REGISTER_PARAM_password: (password == nil) ? @"": password,
                             URL_REGISTER_PARAM_email: (email == nil) ? @"": email,
                             URL_REGISTER_PARAM_timezone: (timeZone == nil)? @"": timeZone
                             };
    
    [self executePOSTWithParams:params
                         forURL:URL_REGISTER
                   onCompletion:^(NSDictionary *response) {
                       
                       if ([CMSNetworkManager isResponseValid:response]) {
                           if (objectBlock != nil) {
                               objectBlock(response);
                           }
                           else if (self.registerDelegate != nil && [self.registerDelegate respondsToSelector:@selector(CMSNetworkManager:didRegisterWithResponse:)]) {
                               [self.registerDelegate CMSNetworkManager:self didRegisterWithResponse:response];
                           }
                       }
                       else{
                           NSError *error = [CMSNetworkManager getError:response];
                           if (failBlock != nil) {
                               failBlock(error);
                           }
                           else if (self.registerDelegate != nil && [self.registerDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToRegisterWithError:)]) {
                               [self.registerDelegate CMSNetworkManager:self didFailToRegisterWithError:error];
                           }
                       }
                       
                   }
                     onFaillure:^(NSError *error) {
                         
                         if (failBlock != nil) {
                             failBlock(error);
                         }
                         else if (self.registerDelegate != nil && [self.registerDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToRegisterWithError:)]) {
                             [self.registerDelegate CMSNetworkManager:self didFailToRegisterWithError:error];
                         }
                     }
                     showLoader:showLoader
     ];
}

- (void)recoverPasswordWithEmail:(NSString *)email
                    onCompletion:(CMSResponseBlock)objectBlock
                      onFaillure:(CMSErrorBlock)failBlock
                      showLoader:(BOOL)showLoader{
    
    NSDictionary *params = @{
                             URL_RECOVER_PASSWORD_PARAM_email: (email == nil) ? @"": email
                             };
    
    [self executePOSTWithParams:params
                         forURL:URL_RECOVER_PASSWORD
                   onCompletion:^(NSDictionary *response) {
                       
                       if ([CMSNetworkManager isResponseValid:response]) {
                           if (objectBlock != nil) {
                               objectBlock(response);
                           }
                           else if (self.recoverPasswordDelegate != nil && [self.recoverPasswordDelegate respondsToSelector:@selector(CMSNetworkManager:didRecoverPasswordWithResponse:)]) {
                               [self.recoverPasswordDelegate CMSNetworkManager:self didRecoverPasswordWithResponse:response];
                           }
                       }
                       else{
                           NSError *error = [CMSNetworkManager getError:response];
                           if (failBlock != nil) {
                               failBlock(error);
                           }
                           else if (self.recoverPasswordDelegate != nil && [self.recoverPasswordDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToRecoverPasswordWithError:)]) {
                               [self.recoverPasswordDelegate CMSNetworkManager:self didFailToRecoverPasswordWithError:error];
                           }
                       }
                   }
                     onFaillure:^(NSError *error) {
                         
                         if (failBlock != nil) {
                             failBlock(error);
                         }
                         else if (self.recoverPasswordDelegate != nil && [self.recoverPasswordDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToRecoverPasswordWithError:)]) {
                             [self.recoverPasswordDelegate CMSNetworkManager:self didFailToRecoverPasswordWithError:error];
                         }
                     }
                     showLoader:showLoader
     ];
}

- (void)feedbackWithTitle:(NSString *)title
                    email:(NSString *)email
                     post:(NSString *)post
             onCompletion:(CMSResponseBlock)objectBlock
               onFaillure:(CMSErrorBlock)failBlock
               showLoader:(BOOL)showLoader{
    
    NSDictionary *params = @{
                             URL_FEEDBACK_PARAM_title: (title == nil) ? @"": title,
                             URL_FEEDBACK_PARAM_email: (email == nil) ? @"": email,
                             URL_FEEDBACK_PARAM_post: (post == nil) ? @"": post
                             };
    
    [self executePOSTWithParams:params
                         forURL:URL_FEEDBACK
                   onCompletion:^(NSDictionary *response) {
                       
                       if ([CMSNetworkManager isResponseValid:response]) {
                           if (objectBlock != nil) {
                               objectBlock(response);
                           }
                           else if (self.feedbackDelegate != nil && [self.feedbackDelegate respondsToSelector:@selector(CMSNetworkManager:didFeedbackWithResponse:)]) {
                               [self.feedbackDelegate CMSNetworkManager:self didFeedbackWithResponse:response];
                           }
                       }
                       else{
                           NSError *error = [CMSNetworkManager getError:response];
                           if (failBlock != nil) {
                               failBlock(error);
                           }
                           else if (self.feedbackDelegate != nil && [self.feedbackDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToFeedbackWithError:)]) {
                               [self.feedbackDelegate CMSNetworkManager:self didFailToFeedbackWithError:error];
                           }
                       }
                   }
                     onFaillure:^(NSError *error) {
                         
                         if (failBlock != nil) {
                             failBlock(error);
                         }
                         else if (self.feedbackDelegate != nil && [self.feedbackDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToFeedbackWithError:)]) {
                             [self.feedbackDelegate CMSNetworkManager:self didFailToFeedbackWithError:error];
                         }
                     }
                     showLoader:showLoader
     ];
}

- (void)savePushTokenWithToken:(NSString *)deviceToken
                  onCompletion:(CMSResponseBlock)objectBlock
                    onFaillure:(CMSErrorBlock)failBlock
                    showLoader:(BOOL)showLoader{
    
    NSDictionary *params = @{
                             URL_PUSH_NOTIFICATION_PARAM_token: (deviceToken == nil) ? @"": deviceToken,
                             URL_PUSH_NOTIFICATION_PARAM_member: ([CMS_Users get_member] == -1) ? @"1": [NSString stringWithFormat:@"%d",[CMS_Users get_member]]
                             };
    
    [self executePOSTWithParams:params
                         forURL:URL_PUSH_NOTIFICATION_SETUP
                   onCompletion:^(NSDictionary *response) {
                       
                       if ([CMSNetworkManager isResponseValid:response]) {
                           [CMS_Preferences set_value:deviceToken :URL_PUSH_NOTIFICATION_PARAM_token];
                           
                           if (objectBlock != nil) {
                               objectBlock(response);
                           }
                           else if (self.pushTokenDelegate != nil && [self.pushTokenDelegate respondsToSelector:@selector(CMSNetworkManager:didSavePushTokenWithResponse:)]) {
                               [self.pushTokenDelegate CMSNetworkManager:self didSavePushTokenWithResponse:response];
                           }
                       }
                       else{
                           NSError *error = [CMSNetworkManager getError:response];
                           if (failBlock != nil) {
                               failBlock(error);
                           }
                           else if (self.pushTokenDelegate != nil && [self.pushTokenDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToSavePushTokenWithError:)]) {
                               [self.pushTokenDelegate CMSNetworkManager:self didFailToSavePushTokenWithError:error];
                           }
                       }
                   }
                     onFaillure:^(NSError *error) {
                         
                         if (failBlock != nil) {
                             failBlock(error);
                         }
                         else if (self.pushTokenDelegate != nil && [self.pushTokenDelegate respondsToSelector:@selector(CMSNetworkManager:didFailToSavePushTokenWithError:)]) {
                             [self.pushTokenDelegate CMSNetworkManager:self didFailToSavePushTokenWithError:error];
                         }
                     }
                     showLoader:showLoader
     ];
}

@end
