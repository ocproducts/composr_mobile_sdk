package com.example.cms_sdk_sample;

import java.util.HashMap;
import java.util.Map;

import android.widget.Toast;

import com.ocproducts.composr.sdk.utilities.CMS_Forms;
import com.ocproducts.composr.sdk.utilities.CMS_Forms.CMS_Forms_Callback;

public class Forms extends CMS_Forms implements CMS_Forms_Callback {

	@Override
	protected void initForm() {
		super.initForm();
		setTitle("Sample Form");
		
		form_input_field_spacer_withHeading("Personal Details", "Please fill in your personal details.");
		form_input_uploaded_picture_withPrettyName("Profile Pic", "Upload your profile pic", "photo", true);
		form_input_tick_withPrettyName("Newsletter", "Subscribe for newsletter ?", "newsletter", true);
		
		Map<String, String> options = new HashMap<String, String>();
		options.put("m", "male");
		options.put("f", "female");
		form_input_list_withPrettyName("Gender", "Select gender", "gender", options, 0, true);
		
		form_input_integer_withPrettyName("test int", "test description", "int1", "123", true);
		form_input_date_withPrettyName("DOB", "Provide your DOB", "dob", true, "1/1/1990", true);
		
		form_input_field_spacer_withHeading("Educational Details", "Please fill in your educational details.");
		form_input_text_withPrettyName("Degree Percentage", "", "degree_completion", "0", true);
		form_input_integer_withPrettyName("Degree Completion", "", "dp", "0", true);
		
		set_button_withName("Done", this, false);
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
		Toast.makeText(this, "Called post callback after form submission", Toast.LENGTH_SHORT).show();
	}

}
