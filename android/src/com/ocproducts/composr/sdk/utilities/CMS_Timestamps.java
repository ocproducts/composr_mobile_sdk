package com.ocproducts.composr.sdk.utilities;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/*

CMS_Timestamps

get_timezoned_date(int timestamp, bool includeTime) - turns a unix timestamp into a written date or date&time, in the phone's timezone
int time() - returns unix timestamp

*/

public class CMS_Timestamps {

	public static String get_timezoned_date(long timestamp, boolean includeTime) {
		SimpleDateFormat df;
	    
	    if (includeTime) {
	    	df = new SimpleDateFormat("MMM dd, yyyy - HH:mm:ss", Locale.getDefault());
	    }
	    else {
	    	df = new SimpleDateFormat("MMM dd, yyyy", Locale.getDefault());
	    }
	    
	    return df.format(new Date(timestamp));
	}
	
	public static long time() {
		return new Date().getTime();
	}
}
