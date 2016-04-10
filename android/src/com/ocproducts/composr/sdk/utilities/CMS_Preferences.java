package com.ocproducts.composr.sdk.utilities;

import android.content.Context;
import android.content.SharedPreferences;

/*

CMS_Preferences

string get_value - gets an ad-hoc preference value
set_value(string name, string value) - sets an ad-hoc preference value

*/

public class CMS_Preferences {

	public static String get_value(String string, Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(string, "");
	}
	
	public static void set_value(String name, String value, Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        SharedPreferences.Editor prefEditor = preferences.edit();
        prefEditor.putString(name, value);
        prefEditor.commit();
	}
	
	public static void set_value(String name, boolean value, Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        SharedPreferences.Editor prefEditor = preferences.edit();
        prefEditor.putBoolean(name, value);
        prefEditor.commit();
	}
	
	public static void set_value(String name, int value, Context context) {
		SharedPreferences preferences = context.getSharedPreferences(Constants.USER_PREFS, Context.MODE_PRIVATE);
        SharedPreferences.Editor prefEditor = preferences.edit();
        prefEditor.putInt(name, value);
        prefEditor.commit();
	}
}
