package com.ocproducts.composr.sdk.utilities;

import java.util.HashMap;
import java.util.Map;

import com.ocproducts.composr.sdk.R;
import com.google.android.gcm.GCMRegistrar;
import com.ocproducts.composr.sdk.CMS_LoginActivity;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

public class CMS_Notification {

	public static void registerForRemoteNotifications(Context context) {
		// Make sure the device has the proper dependencies.
        GCMRegistrar.checkDevice(context);
 
        // Make sure the manifest was properly set - comment out this line
        // while developing the app, then uncomment it when it's ready.
        GCMRegistrar.checkManifest(context);
         
        // Get GCM registration id
        final String regId = GCMRegistrar.getRegistrationId(context);
 
        // Check if regid already presents
        if (regId.equals("")) {
            // Registration is not present, register now with GCM           
            GCMRegistrar.register(context, Constants.GOOGLE_CONSOLE_PROJECT_NUMBER);
        } else {
            // Device is already registered on GCM
            if (GCMRegistrar.isRegisteredOnServer(context)) {
                // Skips registration.              
                Toast.makeText(context, "Already registered with GCM", Toast.LENGTH_LONG).show();
            } else {
                notifyDeviceTokenToServer(context, regId);
            }
        }
	}
	
	public static void notifyDeviceTokenToServer(Context context, String deviceToken) {
		Map<String, String> loginParams = new HashMap<String, String>();
		loginParams.put(Constants.URL_REGISTER_PUSH_PARAM_token, deviceToken);
		new CMS_AsyncTask(Constants.URL_REGISTER_PUSH, true, loginParams, null, Constants.kHTTPTimeout, context).execute();
	}
	
	public static void showNotification(Context context, String message) {
		int icon = R.drawable.ic_launcher;
        long when = System.currentTimeMillis();
        NotificationManager notificationManager = (NotificationManager)
                context.getSystemService(Context.NOTIFICATION_SERVICE);
        Notification notification = new Notification(icon, message, when);
        
        String title = context.getString(R.string.app_name);
        
        Intent notificationIntent = new Intent(context, CMS_LoginActivity.class);
        
        // set intent so it does not start a new activity
        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP |
                Intent.FLAG_ACTIVITY_SINGLE_TOP);
        PendingIntent intent =
                PendingIntent.getActivity(context, 0, notificationIntent, 0);
        notification.setLatestEventInfo(context, title, message, intent);
        notification.flags |= Notification.FLAG_AUTO_CANCEL;

        notification.defaults |= Notification.DEFAULT_SOUND;
        notification.defaults |= Notification.DEFAULT_VIBRATE;
        notificationManager.notify(0, notification); 
	}
}
