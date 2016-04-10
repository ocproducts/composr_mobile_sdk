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

public class CMS_PasswordResetActivity extends Activity implements CMS_AsyncTask_Callback {
	
	private EditText emailTextView;
	private Button btnSubmit;
	private Button btnCancel;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_cms_password_reset);
		
		emailTextView = (EditText) findViewById(R.id.txtEmail);
		btnSubmit = (Button) findViewById(R.id.btnSubmit);
		btnCancel = (Button) findViewById(R.id.btnCancel);
		
		btnCancel.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		
		btnSubmit.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				if (validate()) {
					Map<String, String> passwordResetParams = new HashMap<String, String>();
					passwordResetParams.put(Constants.URL_RECOVER_PASSWORD_PARAM_email, emailTextView.getText().toString());
					NetworkManager.sharedManager().executeRequest(Constants.URL_RECOVER_PASSWORD, true, passwordResetParams, null, Constants.kHTTPTimeout, CMS_PasswordResetActivity.this);
				}
			}
		});
	}
	
	private boolean validate() {
		if (!"".equals(emailTextView.getText().toString().trim())) {
			return true;
		}
		return false;
	}

	@Override
	public void CMS_AsyncTask_Completed_With_Result(String result) {
		
		if (result != null) {
			JSONObject resultJson;
			try {
				resultJson = CMS_HTTP.json_decode(result);
				if (CMS_AsyncTask.isResponseValid(resultJson)) {
					CMS_Flow.inform_screen(CMS_PasswordResetActivity.this, CMS_AsyncTask.getResponseData(resultJson).optString("message"));
				} else {
					CMS_Flow.inform_screen(CMS_PasswordResetActivity.this, CMS_AsyncTask.getError(resultJson));
					return;
				}
			} catch (JSONException e) {
				e.printStackTrace();
				CMS_Flow.warn_screen(CMS_PasswordResetActivity.this, "Server Error!!!");
			}
		}

		Toast.makeText(getApplicationContext(), "Signup Failed", Toast.LENGTH_SHORT).show();
	}
}
