package com.ocproducts.composr.sdk.utilities;

import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import com.ocproducts.composr.sdk.R;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.view.ContextThemeWrapper;

public class CMS_AsyncTask extends AsyncTask<Void, Void, String> {
	
	public static interface CMS_AsyncTask_Callback {
		public void CMS_AsyncTask_Completed_With_Result(String result);
	}
	
	public static boolean isResponseValid(JSONObject response) {
		try {
			if (response != null && response.getString("success").equals("true")) {
				return true;
			}
		} catch (Exception e) {
			// do nothing
		}
		return false;
	}
	
	public static JSONObject getResponseData(JSONObject response) {
		if (isResponseValid(response)) {
			try {
				return response.getJSONObject("response_data");
			} catch (JSONException e) {
				// do nothing
			}
		}
		return new JSONObject();
	}
	
	public static String getError(JSONObject response) {
		if (!isResponseValid(response)) {
			if (response != null) {
				try {
					String errorDetails = response.getString("error_details");
					if (errorDetails == null || errorDetails.trim().equals("")) {
						return "Sorry. Something went wrong.";
					}
					return errorDetails;
				} catch (JSONException e) {
					// do nothing
				}
			}
		}
		return "Sorry. Something went wrong.";
	}
	
	// The parent context
	private Context context;
	// Dialog displaying a loading message
	private ProgressDialog refreshDialog;
	
	private String url;
	private boolean triggerError;
	private Map<String, String> postParams;
	private Map<String, String> headers;
	private int timeoutInSeconds;
	
	public CMS_AsyncTask(String url, boolean triggerError, Map<String, String> postParams, Map<String, String> headers, int timeoutInSeconds, Context context) {
		this.url = url;
		this.triggerError = triggerError;
		this.postParams = postParams;
		this.headers = headers;
		this.timeoutInSeconds = timeoutInSeconds;
		this.context = context;
	}

	@Override
	protected String doInBackground(Void... params) {
		return CMS_HTTP.http_download_file(url, triggerError, postParams, headers, timeoutInSeconds, (Activity)context);
	}

	@Override
	protected void onPostExecute(String result) {
		super.onPostExecute(result);
		
		if (context instanceof CMS_AsyncTask_Callback) {
			((CMS_AsyncTask_Callback) context).CMS_AsyncTask_Completed_With_Result(result);
		}

		// Dismiss the dialog
		refreshDialog.dismiss();		
	}

	@Override
	protected void onPreExecute() {
		// Create a new dialog
		refreshDialog = new ProgressDialog(new ContextThemeWrapper(context, R.style.AlertBox));
		// Inform of the refresh
		refreshDialog.setMessage("Loading ...");
		// Spin the wheel whilst the dialog exists
		refreshDialog.setIndeterminate(false);
		// Don't exit the dialog when the screen is touched
		refreshDialog.setCanceledOnTouchOutside(false);
		// Don't exit the dialog when back is pressed
		refreshDialog.setCancelable(true);
		// Show the dialog
		refreshDialog.show();
		super.onPreExecute();
	}

}
