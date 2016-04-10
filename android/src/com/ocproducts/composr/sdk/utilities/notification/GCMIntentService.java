package com.ocproducts.composr.sdk.utilities.notification;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.google.android.gcm.GCMBaseIntentService;
import com.google.android.gcm.GCMRegistrar;
import com.ocproducts.composr.sdk.utilities.CMS_Flow;
import com.ocproducts.composr.sdk.utilities.CMS_Notification;
import com.ocproducts.composr.sdk.utilities.CMS_Preferences;
import com.ocproducts.composr.sdk.utilities.Constants;
/**
 * @author priyanka
 * 
 */
public class GCMIntentService extends GCMBaseIntentService {

	private static final String TAG = "GCMIntentService";

    public GCMIntentService() {
    	// Call extended class Constructor GCMBaseIntentService
        super(Constants.GOOGLE_CONSOLE_PROJECT_NUMBER);
    }

    /**
     * Method called on device registered
     **/
    @Override
    protected void onRegistered(Context context, String registrationId) {
    	
    	//Get Global Controller Class object (see application tag in AndroidManifest.xml)
    	
        Log.i(TAG, "Device registered: regId = " + registrationId);
        CMS_Preferences.set_value("GCM_ID", registrationId, context);
        CMS_Flow.inform_screen(context, "Your device registred with GCM");
        
        CMS_Notification.notifyDeviceTokenToServer(context, registrationId);
    }

    /**
     * Method called on device unregistred
     * */
    @Override
    protected void onUnregistered(Context context, String registrationId) {
        Log.i(TAG, "Device unregistered");
        GCMRegistrar.setRegisteredOnServer(context, false);
    }

    /**
     * Method called on Receiving a new message from GCM server
     * */
    @Override
    protected void onMessage(Context context, Intent intent) {
    	
        Log.i(TAG, "Received message");
        String message = intent.getExtras().getString("message");
		
        CMS_Notification.showNotification(context, message);
    }

    /**
     * Method called on receiving a deleted message
     * */
    @Override
    protected void onDeletedMessages(Context context, int total) {
        Log.i(TAG, "Received deleted messages notification");
    }

    /**
     * Method called on Error
     * */
    @Override
    public void onError(Context context, String errorId) {
        Log.i(TAG, "Received error: " + errorId);
    }

    @Override
    protected boolean onRecoverableError(Context context, String errorId) {
        Log.i(TAG, "Received recoverable error: " + errorId);
        return super.onRecoverableError(context, errorId);
    }

}
