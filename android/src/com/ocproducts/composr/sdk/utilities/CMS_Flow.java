package com.ocproducts.composr.sdk.utilities;

import com.ocproducts.composr.sdk.CMS_LoginActivity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;

/*

CMS_Flow

void access_denied() - opens the login view controller, and then have that controller close and the opener view controller refresh
void attach_message(string msg) - creates a popup alert, alert title is 'Message'
void inform_screen(string msg) - creates a popup alert then closes the view controller, alert title is 'Message'
void warn_screen(string msg) - creates a popup alert then closes the view controller, alert title is 'Warning'
void redirect_screen(className viewController) - transfers to a different view controller

*/

public class CMS_Flow {
	
	public static void access_denied(Context context) {
		context.startActivity(new Intent(context, CMS_LoginActivity.class));
	}
	
	public static void access_denied(Context context, String msg) {
		new AlertDialog.Builder(context)
	    .setTitle("Message")
	    .setMessage(msg)
	    .setNegativeButton(android.R.string.ok, new DialogInterface.OnClickListener() {
	        public void onClick(DialogInterface dialog, int which) { 
	            // do nothing
	        }
	     })
	     .show();
	}
	
	public static void inform_screen(final Context context, String msg) {
		new AlertDialog.Builder(context)
	    .setTitle("Message")
	    .setMessage(msg)
	    .setNegativeButton(android.R.string.ok, new DialogInterface.OnClickListener() {
	        public void onClick(DialogInterface dialog, int which) { 
	            if (context instanceof Activity) {
					((Activity) context).finish();
				}
	        }
	     })
	     .show();
	}
	
	public static void warn_screen(final Context context, String msg) {
		new AlertDialog.Builder(context)
	    .setTitle("Warning")
	    .setMessage(msg)
	    .setNegativeButton(android.R.string.ok, new DialogInterface.OnClickListener() {
	        public void onClick(DialogInterface dialog, int which) { 
	            if (context instanceof Activity) {
					((Activity) context).finish();
				}
	        }
	     })
	     .show();
	}
	
	public static void redirect_screen(Activity sourceActivity, Class<Activity> destinationActivity) {
		Intent intent = new Intent(sourceActivity, destinationActivity);
		sourceActivity.startActivity(intent);
	}
}
