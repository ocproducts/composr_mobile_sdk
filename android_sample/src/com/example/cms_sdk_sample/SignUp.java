package com.example.cms_sdk_sample;

import org.json.JSONException;
import org.json.JSONObject;

import com.ocproducts.composr.sdk.utilities.CMS_AsyncTask;
import com.ocproducts.composr.sdk.utilities.CMS_Flow;
import com.ocproducts.composr.sdk.utilities.CMS_Forms;
import com.ocproducts.composr.sdk.utilities.CMS_HTTP;
import com.ocproducts.composr.sdk.utilities.CMS_Forms.CMS_Forms_Callback;

import android.widget.Toast;

public class SignUp extends  CMS_Forms implements CMS_Forms_Callback {

	@Override
	protected void initForm() {
		super.initForm();
		setTitle("SignUp");
		
		form_input_line_withPrettyName("Username", "Username", "username", "", true);
		form_input_password_withPrettyName("Password", "Password", "password", "", true);
		form_input_password_withPrettyName("Confirm Password", "Confirm Password", "password_confirm", "", true);
		form_input_line_withPrettyName("Email", "Email", "email_address", "test", true);
		form_input_line_withPrettyName("Confirm Email", "Confirm Email", "email_address_confirm", "", true);
		form_input_integer_withPrettyName("DOB day", "Day of Birth", "dob_day", "", true);
		form_input_integer_withPrettyName("DOB month", "Month of Birth", "dob_month", "", true);
		form_input_integer_withPrettyName("DOB year", "Year of Birth", "dob_year", "", true);
		set_url("http://staging.ocproducts.com/composr/data/endpoint.php?hook_type=account&hook=join");
		set_button_withName("Signup", this, true);
	}

	@Override
	public void preSubmitGuard() {
		Toast.makeText(this, "Called presubmit guard due to validation error", Toast.LENGTH_SHORT).show();
	}

	@Override
	public void preSubmitCallback() {
		Toast.makeText(this, "Called presubmit callback as autosubmit is false", Toast.LENGTH_SHORT).show();
	}

	@Override
	public void postCallback(String result) {
		if (result != null) {
			JSONObject resultJson;
			try {
				resultJson = CMS_HTTP.json_decode(result);
				if (CMS_AsyncTask.isResponseValid(resultJson)) {
					CMS_Flow.inform_screen(SignUp.this, CMS_AsyncTask.getResponseData(resultJson).optString("message"));
				} else {
					CMS_Flow.inform_screen(SignUp.this, CMS_AsyncTask.getError(resultJson));
					return;
				}
			} catch (JSONException e) {
				e.printStackTrace();
				CMS_Flow.warn_screen(SignUp.this, "Server Error!!!");
			}
		}

		Toast.makeText(getApplicationContext(), "Signup Failed", Toast.LENGTH_SHORT).show();
	}
}
