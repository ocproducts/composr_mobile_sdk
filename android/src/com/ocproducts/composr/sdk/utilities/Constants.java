package com.ocproducts.composr.sdk.utilities;

public class Constants {
	
	/**
     * Sends requests to debugging/development version of Web Services API. Ensure this is false when deploying.
     */
	public static final Boolean DEBUG_MODE = true;

    // Resets database
    public static final Boolean DATABASE_RESET = false;
	
    public static final String BASE_URL = DEBUG_MODE ? "http://staging.ocproducts.com/" : "http://staging.ocproducts.com/";

    // Make the app think it is working offline, for testing
    public static final Boolean WORK_OFFLINE = false;
	
	/**
	 * User preferences storage name
	 */
	public static String USER_PREFS = "userPrefs";

	/**
	 * HTTP Requests Timeout
	 */
	public static int kHTTPTimeout = 8;
	
	/**
	 * Standardized login parameter names
	 */
	public static String k_MemberID = "memberID";
	public static String k_User_PagesBlacklist = "pages_blacklist";
	public static String k_User_Privileges = "privileges";
	public static String k_User_Zones = "zone_access";
	public static String k_isStaff = "staff_status";
	public static String k_isSuperAdmin = "admin_status";
	public static String k_SessionID = "sessionID";
	public static String k_Username = "username";
	public static String k_Members_Groups = "groups";
	public static String k_Password = "password";
	
	/**
	 * Cookie Param Names
	 */
	public static String kHTTPHeader_MemberID_CookieName = "device_auth_member_id_cn";
	public static String kHTTPHeader_MemberID_CookieValue = "device_auth_member_id_vl";
	public static String kHTTPHeader_MemberID_Hashed_CookieName = "device_auth_pass_hashed_cn";
	public static String kHTTPHeader_MemberID_Hashed_CookieValue = "device_auth_pass_hashed_vl";
	
	/**
	 * Login
	 */
	public static final String LOGIN_URL = "composr/data/endpoint.php?hook_type=account&hook=login";
	public static final String URL_LOGIN_PARAM_username = "username";
	public static final String URL_LOGIN_PARAM_password = "password";
	
	/**
	 * Signup
	 */
	public static final String REGISTER_URL = "composr/data/endpoint.php?hook_type=account&hook=join";
	public static final String URL_REGISTER_PARAM_username = "username";
	public static final String URL_REGISTER_PARAM_password = "password";
	public static final String URL_REGISTER_PARAM_confirm_password = "password_confirm";
	public static final String URL_REGISTER_PARAM_email = "email_address";
	public static final String URL_REGISTER_PARAM_confirm_email = "email_address_confirm";
	public static final String URL_REGISTER_PARAM_DOB_day = "dob_day";
	public static final String URL_REGISTER_PARAM_DOB_month = "dob_month";
	public static final String URL_REGISTER_PARAM_DOB_year = "dob_year";
	public static final String URL_REGISTER_PARAM_timezone = "timezone";
	
	/**
	 * Password Reset
	 */
	public static final String URL_RECOVER_PASSWORD = "composr/data/endpoint.php?hook_type=account&hook=lost_password";
	public static final String URL_RECOVER_PASSWORD_PARAM_email = "email_address";

	/**
	 * Contact
	 */
	public static final String URL_FEEDBACK = "composr/data/endpoint.php?hook_type=account&hook=contact_us";
	public static final String URL_FEEDBACK_PARAM_title = "title";
	public static final String URL_FEEDBACK_PARAM_email = "email";
	public static final String URL_FEEDBACK_PARAM_post = "post";
	
	/**
	 * Push Notification
	 */
	public static final String URL_REGISTER_PUSH = "composr/data/endpoint.php?hook_type=account&hook=setup_push_notifications&device=android";
	public static final String URL_REGISTER_PUSH_PARAM_token = "token";
	
	public static String GOOGLE_CONSOLE_PROJECT_NUMBER = "1000878927243";

}
