//
//  CMSNetworkManager.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 03/09/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"

@protocol CMSNetworkManager_LoginDelegate;
@protocol CMSNetworkManager_RegisterDelegate;
@protocol CMSNetworkManager_RecoverPasswordDelegate;
@protocol CMSNetworkManager_FeedbackDelegate;
@protocol CMSNetworkManager_PushTokenDelegate;

typedef void (^CMSErrorBlock)(NSError * error);
typedef void (^CMSResponseBlock)(NSDictionary *response);

@interface CMSNetworkManager : AFHTTPRequestOperationManager

+ (BOOL)isResponseValid:(NSDictionary *)response;
+ (id)getResponseData:(NSDictionary *)response;
+ (NSError *)getError:(NSDictionary *)response;

+ (CMSNetworkManager *)sharedManagerWithUrl:(NSString *)url;
+ (CMSNetworkManager *)sharedManager;
- (instancetype)initWithBaseURL:(NSURL *)url;

@property (nonatomic,weak) id<CMSNetworkManager_LoginDelegate> loginDelegate;
@property (nonatomic,weak) id<CMSNetworkManager_RegisterDelegate> registerDelegate;
@property (nonatomic,weak) id<CMSNetworkManager_RecoverPasswordDelegate> recoverPasswordDelegate;
@property (nonatomic,weak) id<CMSNetworkManager_FeedbackDelegate> feedbackDelegate;
@property (nonatomic,weak) id<CMSNetworkManager_PushTokenDelegate> pushTokenDelegate;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
             onCompletion:(CMSResponseBlock)objectBlock
               onFaillure:(CMSErrorBlock)failBlock
               showLoader:(BOOL)showLoader;

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
                  showLoader:(BOOL)showLoader;

- (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
                       email:(NSString *)email
                    timezone:(NSString *)timeZone
                onCompletion:(CMSResponseBlock)objectBlock
                  onFaillure:(CMSErrorBlock)failBlock
                  showLoader:(BOOL)showLoader;

- (void)recoverPasswordWithEmail:(NSString *)email
                    onCompletion:(CMSResponseBlock)objectBlock
                      onFaillure:(CMSErrorBlock)failBlock
                      showLoader:(BOOL)showLoader;

- (void)feedbackWithTitle:(NSString *)title
                    email:(NSString *)email
                     post:(NSString *)post
             onCompletion:(CMSResponseBlock)objectBlock
               onFaillure:(CMSErrorBlock)failBlock
               showLoader:(BOOL)showLoader;

- (void)savePushTokenWithToken:(NSString *)deviceToken
                  onCompletion:(CMSResponseBlock)objectBlock
                    onFaillure:(CMSErrorBlock)failBlock
                    showLoader:(BOOL)showLoader;
@end

@protocol CMSNetworkManager_LoginDelegate <NSObject>

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didLoginWithResponse:(NSDictionary *)response;
- (void) CMSNetworkManager:(CMSNetworkManager *)manager didFailToLoginWithError:(NSError *)error;

@end

@protocol CMSNetworkManager_RegisterDelegate <NSObject>

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didRegisterWithResponse:(NSDictionary *)response;
- (void) CMSNetworkManager:(CMSNetworkManager *)manager didFailToRegisterWithError:(NSError *)error;

@end

@protocol CMSNetworkManager_RecoverPasswordDelegate <NSObject>

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didRecoverPasswordWithResponse:(NSDictionary *)response;
- (void) CMSNetworkManager:(CMSNetworkManager *)manager didFailToRecoverPasswordWithError:(NSError *)error;

@end

@protocol CMSNetworkManager_FeedbackDelegate <NSObject>

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didFeedbackWithResponse:(NSDictionary *)response;
- (void) CMSNetworkManager:(CMSNetworkManager *)manager didFailToFeedbackWithError:(NSError *)error;

@end

@protocol CMSNetworkManager_PushTokenDelegate <NSObject>

- (void) CMSNetworkManager:(CMSNetworkManager *)manager didSavePushTokenWithResponse:(NSDictionary *)response;
- (void) CMSNetworkManager:(CMSNetworkManager *)manager didFailToSavePushTokenWithError:(NSError *)error;

@end


