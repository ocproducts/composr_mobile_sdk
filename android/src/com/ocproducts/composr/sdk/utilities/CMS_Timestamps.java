package com.ocproducts.composr.sdk.utilities;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/*

CMS_Timestamps

get_timezoned_date_time(int timestamp) - turns a unix timestamp into a written date&time, in the phone's timezone
get_timezoned_date(int timestamp) - turns a unix timestamp into a written date, in the phone's timezone
int time() - returns unix timestamp

*/

public class CMS_Timestamps {

	public static String get_timezoned_date_time(long timestamp) {
		SimpleDateFormat df;
	    
    	df = new SimpleDateFormat("MMM dd, yyyy - HH:mm:ss", Locale.getDefault());
	    
	    return df.format(new Date(timestamp));
	}
	
	public static String get_timezoned_date(long timestamp) {
		SimpleDateFormat df;
	    
    	df = new SimpleDateFormat("MMM dd, yyyy", Locale.getDefault());
	    
	    return df.format(new Date(timestamp));
	}
	
	public static long time() {
		return new Date().getTime();
	}
}
