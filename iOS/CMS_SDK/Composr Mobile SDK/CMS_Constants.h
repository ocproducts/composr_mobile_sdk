//
//  Constants.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 04/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#ifndef Composr_Mobile_SDK_Constants_h

#define Composr_Mobile_SDK_Constants_h

// This must not be defined for live releases!
#define DEVELOPMENT

/**
 Web Service API Endpoints
 **/

#ifdef DEVELOPMENT
#define k_WEBSERVICES_DOMAIN                            @"http://staging.ocproducts.com/composr/data/endpoint.php"
#define k_WEBSERVICES_PATH                              @""
#else
#define k_WEBSERVICES_DOMAIN                            @"ocportal.com"
#define k_WEBSERVICES_PATH                              @"xmlservice"
#endif

/**
 Standardised login parameter names
 **/

#define k_MemberID                                      @"memberID"
#define k_User_PagesBlacklist                           @"pages_blacklist"
#define k_User_Privileges                               @"privileges"
#define k_User_Zones                                    @"zone_access"
#define k_isStaff                                       @"staff_status"
#define k_isSuperAdmin                                  @"admin_status"
#define k_SessionID                                     @"sessionID"
#define k_Username                                      @"username"
#define k_Members_Groups                                @"groups"
#define k_Password                                      @"password"

/**
 HTTP
 **/

#define kHTTP_GetMethod                                 @"GET"
#define kHTTP_PostMethod                                @"POST"
#define kHTTPTimeout                                    8.0

#define kHTTPHeader_MemberID_CookieName                 @"device_auth_member_id_cn"
#define kHTTPHeader_MemberID_CookieValue                @"device_auth_member_id_vl"
#define kHTTPHeader_MemberID_Hashed_CookieName          @"device_auth_pass_hashed_cn"
#define kHTTPHeader_MemberID_Hashed_CookieValue         @"device_auth_pass_hashed_vl"

/**
 URLS
 **/

#define URL_LOGIN                                       @"?hook_type=account&hook=login"
#define URL_LOGIN_PARAM_username                        @"username"
#define URL_LOGIN_PARAM_password                        @"password"

#define URL_RECOVER_PASSWORD                            @"?hook_type=account&hook=lost_password"
#define URL_RECOVER_PASSWORD_PARAM_email                @"email_address"

#define URL_REGISTER                                    @"?hook_type=account&hook=join"
#define URL_REGISTER_PARAM_username                     @"username"
#define URL_REGISTER_PARAM_password                     @"password"
#define URL_REGISTER_PARAM_confirm_password             @"password_confirm"
#define URL_REGISTER_PARAM_email                        @"email_address"
#define URL_REGISTER_PARAM_confirm_email                @"email_address_confirm"
#define URL_REGISTER_PARAM_DOB_day                      @"dob_day"
#define URL_REGISTER_PARAM_DOB_month                    @"dob_month"
#define URL_REGISTER_PARAM_DOB_year                     @"dob_year"
#define URL_REGISTER_PARAM_timezone                     @"timezone"

#define URL_FEEDBACK                                    @"?hook_type=misc&hook=contact_us"
#define URL_FEEDBACK_PARAM_title                        @"title"
#define URL_FEEDBACK_PARAM_email                        @"email"
#define URL_FEEDBACK_PARAM_post                         @"post"

#define URL_PUSH_NOTIFICATION_SETUP                     @"?hook_type=account&hook=setup_push_notifications&device=ios"
#define URL_PUSH_NOTIFICATION_PARAM_token               @"token"
#define URL_PUSH_NOTIFICATION_PARAM_member              @"member"

/**
 STORYBOARD
 **/

#define CMS_STORYBOARD_NAME                             @"CMS"

#endif
