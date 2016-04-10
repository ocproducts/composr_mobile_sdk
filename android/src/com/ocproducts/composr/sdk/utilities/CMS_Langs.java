package com.ocproducts.composr.sdk.utilities;

import android.content.Context;

/*

CMS_Langs

string do_lang(string strName, array parameters) -- lookup a translation string, with a list of parameters for it

*/

public class CMS_Langs {
	
	public static String do_lang(String key, Context context) {
		int id = context.getResources().getIdentifier(key, "string", context.getPackageName());
		if (id == 0) {
			return "";
		}
		return context.getResources().getText(id).toString();
	}
}