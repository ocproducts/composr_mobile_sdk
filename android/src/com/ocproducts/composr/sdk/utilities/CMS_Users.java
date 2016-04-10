package com.ocproducts.composr.sdk.utilities;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.content.SharedPreferences;

/*

CMS_Users

bool has_page_access() - works using data retrieved when logging in
bool has_privilege(string privilegeName) - works using data retrieved when logging in
bool has_zone_access(string zoneName) - works using data retrieved when logging in
bool is_staff() - works using data retrieved when logging in
bool is_super_admin() - works using data retrieved when logging in
int get_member() - works using data retrieved when logging in
int get_session_id() - works using data retrieved when logging in
string get_username() - works using data retrieved when logging in
array get_members_groups() - works using data retrieved when logging in
array get_members_groups_names() - works using data retrieved when logging in
string get_value - gets a member setting (lots of these stored when logging in, using standard ad-hoc preferences mechanism)

*/

public class CMS_Users {

	public static boolean has_page_access(Context context, String page) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
		List<String> blackListedPages = CMS_Arrays.explode(",", preferences.getString(Constants.k_User_PagesBlacklist, ""));
		return !CMS_Arrays.in_array(page, blackListedPages);
	}
	
	public static boolean has_privilege(String privilageName, Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        List<String> privilages = CMS_Arrays.explode(",", preferences.getString(Constants.k_User_Privileges, ""));
        return CMS_Arrays.in_array(privilageName, privilages);
	}
	
	public static boolean has_zone_access(String zoneName, Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        List<String> zones = CMS_Arrays.explode(",", preferences.getString(Constants.k_User_Zones, ""));
        return CMS_Arrays.in_array(zoneName, zones);
	}
	
	public static boolean is_staff(Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        return preferences.getBoolean(Constants.k_isStaff, false);
	}
	
	public static boolean is_super_admin(Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        return preferences.getBoolean(Constants.k_isSuperAdmin, false) && !is_staff(context);
	}
	
	public static int get_member(Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        return preferences.getInt(Constants.k_MemberID, -1);
	}
	
	public static int get_session_id(Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        return preferences.getInt(Constants.k_SessionID, -1);
	}
	
	public static String get_username(Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(Constants.k_Username, "");
	}
	
	public static List<Map<String, String>> get_member_groups(Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        List<String> memberGroupsFlatMaps = CMS_Arrays.explode(",", preferences.getString(Constants.k_Members_Groups, ""));
        ArrayList<Map<String, String>> memberGroups = new ArrayList<Map<String,String>>();
        for (String mapString : memberGroupsFlatMaps) {
			memberGroups.add(CMS_Arrays.stringToMap(mapString));
		}
        return memberGroups;
	}
	
	public static List<String> get_members_groups_names(Context context) {
		return CMS_Arrays.collapse_1d_complexity("name", CMS_Users.get_member_groups(context));
	}
	
	public static String get_value(String key, Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(key, "");
	}
	
	public static String get_password(Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(Constants.k_Password, "");
	}
}
