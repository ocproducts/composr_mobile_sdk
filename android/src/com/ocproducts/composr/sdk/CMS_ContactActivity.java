package com.ocproducts.composr.sdk;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import com.ocproducts.composr.sdk.utilities.CMS_AsyncTask;
import com.ocproducts.composr.sdk.utilities.CMS_Flow;
import com.ocproducts.composr.sdk.utilities.CMS_HTTP;
import com.ocproducts.composr.sdk.utilities.Constants;
import com.ocproducts.composr.sdk.utilities.NetworkManager;
import com.ocproducts.composr.sdk.utilities.CMS_AsyncTask.CMS_AsyncTask_Callback;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class CMS_ContactActivity extends Activity implements CMS_AsyncTask_Callback {
	
	EditText txtSubject;
	EditText txtEmail;
	EditText txtMessage;
	Button btnSave;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_cms_contact);
		
		txtSubject = (EditText) findViewById(R.id.txtSubject);
		txtEmail = (EditText) findViewById(R.id.txtEmail);
		txtMessage = (EditText) findViewById(R.id.txtMessage);
		btnSave = (Button) findViewById(R.id.btnSave);
		
		btnSave.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				String message = validate();
				if (message == null) {
					Map<String, String> signupParams = new HashMap<String, String>();
					signupParams.put(Constants.URL_FEEDBACK_PARAM_title, txtSubject.getText().toString());
					signupParams.put(Constants.URL_FEEDBACK_PARAM_email, txtEmail.getText().toString());
					signupParams.put(Constants.URL_FEEDBACK_PARAM_post, txtMessage.getText().toString());
					NetworkManager.sharedManager().executeRequest(Constants.URL_FEEDBACK, true, signupParams, null, Constants.kHTTPTimeout, CMS_ContactActivity.this);
				} else {
					CMS_Flow.warn_screen(CMS_ContactActivity.this, message);
				}
			}
		});
	}
	
	private String validate() {
		String errorMessage = null;
	    
	    if (!(txtSubject.getText().toString().length() >= 1)){
	        errorMessage = "Please enter a Subject";
	    } else if (!(txtEmail.getText().toString().length() >= 1)){
	        errorMessage = "Please enter your email address";
	    } else if (!(txtMessage.getText().toString().length() >= 1)){
	        errorMessage = "Please enter a message";
	    }
		return errorMessage;
	}

	@Override
	public void CMS_AsyncTask_Completed_With_Result(String result) {
		
		if (result != null) {
			JSONObject resultJson;
			try {
				resultJson = CMS_HTTP.json_decode(result);
				if (CMS_AsyncTask.isResponseValid(resultJson)) {
					CMS_Flow.inform_screen(CMS_ContactActivity.this, CMS_AsyncTask.getResponseData(resultJson).optString("message"));
				} else {
					CMS_Flow.inform_screen(CMS_ContactActivity.this, CMS_AsyncTask.getError(resultJson));
					return;
				}
			} catch (JSONException e) {
				e.printStackTrace();
				CMS_Flow.warn_screen(CMS_ContactActivity.this, "Server Error!!!");
			}
		}

		Toast.makeText(getApplicationContext(), "Signup Failed", Toast.LENGTH_SHORT).show();
	}
}
