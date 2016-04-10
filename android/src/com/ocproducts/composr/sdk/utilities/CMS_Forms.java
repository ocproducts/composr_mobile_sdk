package com.ocproducts.composr.sdk.utilities;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.ocproducts.composr.sdk.R;
import com.ocproducts.composr.sdk.utilities.CMS_AsyncTask.CMS_AsyncTask_Callback;
import com.ocproducts.composr.sdk.utilities.forms.FormActivity;
import com.ocproducts.composr.sdk.utilities.forms.controllers.CheckBoxController;
import com.ocproducts.composr.sdk.utilities.forms.controllers.DatePickerController;
import com.ocproducts.composr.sdk.utilities.forms.controllers.EditTextController;
import com.ocproducts.composr.sdk.utilities.forms.controllers.FormSectionController;
import com.ocproducts.composr.sdk.utilities.forms.controllers.PhotoUploadController;
import com.ocproducts.composr.sdk.utilities.forms.controllers.SelectionController;

import android.graphics.BitmapFactory;
import android.text.InputType;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class CMS_Forms extends FormActivity implements CMS_AsyncTask_Callback {
	
	public interface CMS_Forms_Callback {
		void preSubmitGuard();
		void preSubmitCallback();
		void postCallback(String result);
	}
	
	private List<String> paramNames = new ArrayList<String>();
	FormSectionController section = new FormSectionController(this);
	
	String url = "";
	CMS_Forms_Callback delegate;
	
	@Override
	protected void initForm() {
		setTitle("CMS_Form");
		getFormController().addSection(section);
	}
	
	public CMS_Forms_Callback getDelegate() {
		return delegate;
	}

	public void setDelegate(CMS_Forms_Callback delegate) {
		this.delegate = delegate;
	}
	
	public void form_input_field_spacer_withHeading(String heading, String text) {
		section = new FormSectionController(this, heading, text);
		getFormController().addSection(section);
	}
	
	public void form_input_hidden_withParamName(String paramName, String paramValue) {
		paramNames.add(paramName);
		section.addElement(new EditTextController(this, paramName, paramName, "", paramValue));
		recreateViews();
	}

	public void form_input_integer_withPrettyName(String prettyName, String description, String paramName, String defaultName, boolean isRequired) {
		paramNames.add(paramName);
		section.addElement(new EditTextController(this, paramName, prettyName, description, defaultName, isRequired, InputType.TYPE_CLASS_NUMBER));
		recreateViews();
	}
	
	public void form_input_float_withPrettyName(String prettyName, String description, String paramName, String defaultName, boolean isRequired) {
		paramNames.add(paramName);
		section.addElement(new EditTextController(this, paramName, prettyName, description, defaultName, isRequired, InputType.TYPE_NUMBER_FLAG_DECIMAL));
		recreateViews();
	}
	
	public void form_input_line_withPrettyName(String prettyName, String description, String paramName, String defaultName, boolean isRequired) {
		paramNames.add(paramName);
		section.addElement(new EditTextController(this, paramName, prettyName, description, defaultName, isRequired, InputType.TYPE_CLASS_TEXT));
		recreateViews();
	}
	
	public void form_input_list_withPrettyName(String prettyName, String description, String paramName, Map<String, String> options, int defaultValueIndex, boolean isRequired) {
		paramNames.add(paramName);
		List<String> names = new ArrayList<String>();
		List<String> values = new ArrayList<String>();
		for (String name : options.keySet()) {
			values.add(name);
			names.add(options.get(name));
		}
		section.addElement(new SelectionController(this, paramName, prettyName, isRequired, description, names, values, defaultValueIndex));
		recreateViews();
	}
	
	public void form_input_text_withPrettyName(String prettyName, String description, String paramName, String defaultName, boolean isRequired) {
		paramNames.add(paramName);
		EditTextController editTextController = new EditTextController(this, paramName, prettyName, description, defaultName, isRequired, InputType.TYPE_TEXT_FLAG_MULTI_LINE);
		section.addElement(editTextController);
		recreateViews();
	}
	
	public void form_input_password_withPrettyName(String prettyName, String description, String paramName, String defaultName, boolean isRequired) {
		paramNames.add(paramName);
		EditTextController editTextController = new EditTextController(this, paramName, prettyName, description, defaultName, isRequired, InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
		section.addElement(editTextController);
		recreateViews();
	}
	
	public void form_input_tick_withPrettyName(String prettyName, String description, String paramName, boolean defaultValue) {
		paramNames.add(paramName);
		section.addElement(new CheckBoxController(this, paramName, prettyName, defaultValue, Arrays.asList(description), Arrays.asList("true")));
		recreateViews();
	}
	
	public void form_input_uploaded_picture_withPrettyName(String prettyName, String description, String paramName, boolean isRequired) {
		paramNames.add(paramName);
		section.addElement(new PhotoUploadController(this, paramName, description, isRequired, BitmapFactory.decodeResource(getResources(),
                R.drawable.ic_launcher)));
		recreateViews();
	}
	
	public void form_input_date_withPrettyName(String prettyName, String description, String paramName, boolean isRequired, String defaultValue, boolean includeTimeChoice) {
		paramNames.add(paramName);
		SimpleDateFormat dateformat = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
		if (includeTimeChoice) {
			dateformat = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss", Locale.getDefault());
		}
		section.addElement(new DatePickerController(this, paramName, prettyName, isRequired, dateformat, defaultValue));
		recreateViews();
	}
	
	public long get_input_date(String paramName) {
		try {
			return (new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())).parse(getModel().getValue(paramName).toString()).getTime();
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	public String post_param(String paramName) {
		return getModel().getValue(paramName).toString();
	}
	
	public int post_param_integer(String paramName) {
		return Integer.parseInt(getModel().getValue(paramName).toString());
	}
	
	public void set_intro_text(String text) {
		setTitle(text);
	}
	
	public void set_url(String url) {
		this.url = url;
	}
	
	public void set_button_withName(String name, CMS_Forms_Callback delegate, final boolean autoSubmit) {
		this.delegate = delegate;
		
		Button submitBtn = (Button) findViewById(R.id.form_submit_btn);
		submitBtn.setText(name);
		
		submitBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				if (autoSubmit) {
					do_http_post_request();
				} else {
					doValidateForm();
				}
			}
		});
	}
	
	public void do_http_post_request() {
		getFormController().resetValidationErrors();
        if (getFormController().isValidInput()) {
    		Map<String, String> requestParams = new HashMap<String, String>();
    		for (String paramName : paramNames) {
    			try {
					requestParams.put(paramName, getModel().getValue(paramName).toString());
				} catch (Exception e) {
					requestParams.put(paramName, "");
				}
    		}
    		new CMS_AsyncTask(url, true, requestParams, null, Constants.kHTTPTimeout, this).execute();
        } else {
        	getFormController().showValidationErrors();
        	if (delegate != null) {
            	delegate.preSubmitGuard();
			}
        }
	}
	
	public void doValidateForm() {
		if (!validateForm()) {
			if (delegate!=null) {
				delegate.preSubmitGuard();
			}
		} else {
			if (delegate!=null) {
				delegate.preSubmitCallback();
			}
		}
	}
	
	public boolean validateForm() {
		getFormController().resetValidationErrors();
        if (getFormController().isValidInput()) {
        	return true;
        }
        getFormController().showValidationErrors();
		return false;
	}

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.form_actionbar, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)  {
        super.onOptionsItemSelected(item);
        do_http_post_request();
        return true;
    }

	@Override
	public void CMS_AsyncTask_Completed_With_Result(String result) {
		if (delegate != null) {
			delegate.postCallback(result);
		}
	}
}
