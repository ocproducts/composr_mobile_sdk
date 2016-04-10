package com.ocproducts.composr.sdk;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
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
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.DatePickerDialog.OnDateSetListener;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnDismissListener;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Toast;

public class CMS_SignupActivity extends Activity implements CMS_AsyncTask_Callback {
	
	EditText txtUsername;
	EditText txtPassword;
	EditText txtConfirmPassword;
	EditText txtEmail;
	EditText txtConfirmEmail;
	EditText txtDOB;
	
	Button btnSubmit;
	Button btnCancel;
	
	SimpleDateFormat dateformat;
	Date DOB;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_cms_signup);
		
		txtUsername = (EditText) findViewById(R.id.txtUsername);
		txtPassword = (EditText) findViewById(R.id.txtPassword);
		txtConfirmPassword = (EditText) findViewById(R.id.txtConfirmPassword);
		txtEmail = (EditText) findViewById(R.id.txtEmail);
		txtConfirmEmail = (EditText) findViewById(R.id.txtConfirmEmail);
		txtDOB = (EditText) findViewById(R.id.txtDOB);

		btnSubmit = (Button) findViewById(R.id.btnSignup);
		btnCancel = (Button) findViewById(R.id.btnCancel);
		
		dateformat = new SimpleDateFormat("dd-MM-yyyy", Locale.getDefault());
		txtDOB.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                showDatePickerDialog(CMS_SignupActivity.this, txtDOB);
            }
        });

		txtDOB.setOnFocusChangeListener(new OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if (hasFocus) {
                    showDatePickerDialog(CMS_SignupActivity.this, txtDOB);
                }
            }
        });
		
		btnCancel.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				finish();	
			}
		});
		
		btnSubmit.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				String message = validate();
				if (message == null) {
					String dob_day="0", dob_month="0", dob_year="0";
					String[] parts = txtDOB.getText().toString().split("-");
					dob_day=parts[0]; dob_month=parts[1]; dob_year=parts[2];
					
					Map<String, String> signupParams = new HashMap<String, String>();
					signupParams.put(Constants.URL_REGISTER_PARAM_username, txtUsername.getText().toString());
					signupParams.put(Constants.URL_REGISTER_PARAM_password, txtPassword.getText().toString());
					signupParams.put(Constants.URL_REGISTER_PARAM_confirm_password, txtConfirmPassword.getText().toString());
					signupParams.put(Constants.URL_REGISTER_PARAM_email, txtEmail.getText().toString());
					signupParams.put(Constants.URL_REGISTER_PARAM_confirm_email, txtConfirmEmail.getText().toString());
					signupParams.put(Constants.URL_REGISTER_PARAM_DOB_day, dob_day);
					signupParams.put(Constants.URL_REGISTER_PARAM_DOB_month, dob_month);
					signupParams.put(Constants.URL_REGISTER_PARAM_DOB_year, dob_year);
					NetworkManager.sharedManager().executeRequest(Constants.REGISTER_URL, true, signupParams, null, Constants.kHTTPTimeout, CMS_SignupActivity.this);
				}
				else {
					new AlertDialog.Builder(CMS_SignupActivity.this)
				    .setTitle("Warning")
				    .setMessage(message)
				    .setNegativeButton(android.R.string.ok, new DialogInterface.OnClickListener() {
				        public void onClick(DialogInterface dialog, int which) { 
				        	// do nothing
				        }
				     })
				     .show();
				}
			}
		});
	}
	
	private DatePickerDialog datePickerDialog = null;
	private void showDatePickerDialog(final Context context, final EditText editText) {
        // don't show dialog again if it's already being shown
        if (datePickerDialog == null) {
            Date date = DOB;
            if (date == null) {
                date = new Date();
            }
            Calendar calendar = Calendar.getInstance(Locale.getDefault());
            calendar.setTimeZone(dateformat.getTimeZone());
            calendar.setTime(date);

            datePickerDialog = new DatePickerDialog(context, new OnDateSetListener() {
                @Override
                public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                    Calendar calendar = Calendar.getInstance(Locale.getDefault());
                    calendar.setTimeZone(dateformat.getTimeZone());
                    calendar.set(year, monthOfYear, dayOfMonth);
                    DOB = calendar.getTime();
                    editText.setText(dateformat.format(calendar.getTime()));

                }
            }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH));

            datePickerDialog.setOnDismissListener(new OnDismissListener() {
                @Override
                public void onDismiss(DialogInterface dialog) {
                    datePickerDialog = null;
                }
            });

            datePickerDialog.show();
        }
    }
	
	private String validate() {
		String errorMessage = null;
	    
	    if (!(txtUsername.getText().length() >= 1)){
	        errorMessage = "Please enter a Username";
	    } else if (!(txtPassword.getText().length() >= 5)){
	        errorMessage = "Please enter a Password with minimum of 5 letters";
	    }else if (!txtConfirmPassword.getText().toString().equals(txtPassword.getText().toString())) {
	        errorMessage = "Please correctly re-enter the password";
	    } else if (!android.util.Patterns.EMAIL_ADDRESS.matcher(txtEmail.getText().toString()).matches()){
	        errorMessage = "Please enter a valid email address";
	    } else if (!txtEmail.getText().toString().equals(txtConfirmEmail.getText().toString())) {
	        errorMessage = "Please correctly re-enter the email address";
	    } else if (!(txtDOB.getText().length() > 0)){
	        errorMessage = "Please enter your DOB";
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
					CMS_Flow.inform_screen(CMS_SignupActivity.this, CMS_AsyncTask.getResponseData(resultJson).optString("message"));
				} else {
					CMS_Flow.inform_screen(CMS_SignupActivity.this, CMS_AsyncTask.getError(resultJson));
					return;
				}
			} catch (JSONException e) {
				e.printStackTrace();
				CMS_Flow.warn_screen(CMS_SignupActivity.this, "Server Error!!!");
			}
		}

		Toast.makeText(getApplicationContext(), "Signup Failed", Toast.LENGTH_SHORT).show();
	}
}
