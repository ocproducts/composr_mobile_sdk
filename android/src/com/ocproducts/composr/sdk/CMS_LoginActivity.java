package com.ocproducts.composr.sdk;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import com.ocproducts.composr.sdk.utilities.CMS_AsyncTask;
import com.ocproducts.composr.sdk.utilities.CMS_Flow;
import com.ocproducts.composr.sdk.utilities.CMS_HTTP;
import com.ocproducts.composr.sdk.utilities.CMS_Preferences;
import com.ocproducts.composr.sdk.utilities.Constants;
import com.ocproducts.composr.sdk.utilities.CMS_AsyncTask.CMS_AsyncTask_Callback;
import com.ocproducts.composr.sdk.utilities.NetworkManager;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class CMS_LoginActivity extends Activity implements CMS_AsyncTask_Callback {

	private EditText usernameTextView;
	private EditText passwordTextView;
	private Button loginBtn;
	private Button signupBtn;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.activity_cms_login);
		usernameTextView = (EditText)findViewById(R.id.username);
		passwordTextView = (EditText)findViewById(R.id.password);
		loginBtn = (Button)findViewById(R.id.loginBtn);
		signupBtn = (Button)findViewById(R.id.signupBtn);
		
		loginBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				if (validateLoginFields()) {
					Map<String, String> loginParams = new HashMap<String, String>();
					loginParams.put(Constants.URL_LOGIN_PARAM_username, usernameTextView.getText().toString());
					loginParams.put(Constants.URL_LOGIN_PARAM_password, passwordTextView.getText().toString());
					NetworkManager.sharedManager().executeRequest(Constants.LOGIN_URL, true, loginParams, null, Constants.kHTTPTimeout, CMS_LoginActivity.this);
				}
			}
		});
		
		signupBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				startActivity(new Intent(CMS_LoginActivity.this, CMS_SignupActivity.class));
			}
		});
	}
	
	private boolean validateLoginFields() {
		if (!"".equals(usernameTextView.getText().toString().trim()) && !"".equals(usernameTextView.getText().toString().trim())) {
			return true;
		}
		return false;
	}
	
	public void handleLoginResponse(JSONObject loginResponseData) throws JSONException {
		CMS_Preferences.set_value(Constants.k_Username, loginResponseData.getString(Constants.URL_LOGIN_PARAM_username), CMS_LoginActivity.this);
		CMS_Preferences.set_value(Constants.k_Password, loginResponseData.getString(Constants.URL_LOGIN_PARAM_password), CMS_LoginActivity.this);
		CMS_Preferences.set_value(Constants.kHTTPHeader_MemberID_Hashed_CookieName, loginResponseData.getString(Constants.kHTTPHeader_MemberID_Hashed_CookieName), CMS_LoginActivity.this);
		CMS_Preferences.set_value(Constants.kHTTPHeader_MemberID_Hashed_CookieValue, loginResponseData.getString(Constants.kHTTPHeader_MemberID_Hashed_CookieValue), CMS_LoginActivity.this);
		CMS_Preferences.set_value(Constants.kHTTPHeader_MemberID_CookieName, loginResponseData.getString(Constants.kHTTPHeader_MemberID_CookieName), CMS_LoginActivity.this);
		CMS_Preferences.set_value(Constants.kHTTPHeader_MemberID_CookieValue, loginResponseData.getString(Constants.kHTTPHeader_MemberID_CookieValue), CMS_LoginActivity.this);
		CMS_Preferences.set_value(Constants.k_MemberID, loginResponseData.getString(Constants.kHTTPHeader_MemberID_CookieValue), CMS_LoginActivity.this);
		
		JSONObject userData = (JSONObject) loginResponseData.get("user_data");
		Iterator<String> iterator = userData.keys();
		while (iterator.hasNext()) {
			String key = (String) iterator.next();
			CMS_Preferences.set_value(key, loginResponseData.getString(key), CMS_LoginActivity.this);
		}
		
		Toast.makeText(getApplicationContext(), "Login Successful", Toast.LENGTH_SHORT).show();
	}

	@Override
	public void CMS_AsyncTask_Completed_With_Result(String result) {
		
		if (result != null) {
			JSONObject resultJson;
			try {
				resultJson = CMS_HTTP.json_decode(result);
				if (CMS_AsyncTask.isResponseValid(resultJson)) {
					handleLoginResponse(CMS_AsyncTask.getResponseData(resultJson));
				} else {
					CMS_Flow.inform_screen(CMS_LoginActivity.this, CMS_AsyncTask.getError(resultJson));
					return;
				}
			} catch (JSONException e) {
				e.printStackTrace();
				CMS_Flow.warn_screen(CMS_LoginActivity.this, "Server Error!!!");
			}
		}

		Toast.makeText(getApplicationContext(), "Signup Failed", Toast.LENGTH_SHORT).show();
	}
	
}
