package com.example.cms_sdk_sample;

import java.util.ArrayList;
import java.util.List;

import com.ocproducts.composr.sdk.utilities.CMS_Database;

import android.app.Activity;
import android.app.Dialog;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Toast;
import android.widget.LinearLayout.LayoutParams;
import android.widget.TextView;

public class AddDatabase extends Activity {
	TextView tv;
	LinearLayout linearLayout;
	LinearLayout.LayoutParams layoutParams;
	List<String> fieldsArray;
	String tableName;
	SharedPreferences sp;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.example_add_database);
		tv = (TextView) findViewById(R.id.textView1);
		linearLayout = (LinearLayout) findViewById(R.id.history);
		layoutParams = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,
				LayoutParams.WRAP_CONTENT);
		tableName = getIntent().getExtras().getString("name");
		tv.setText(tableName);
		fieldsArray = new ArrayList<String>();
	}

	public void AddFields(View v) {
		final Dialog d = new Dialog(this);
		d.requestWindowFeature(Window.FEATURE_NO_TITLE);
		d.setContentView(R.layout.example_add_field);

		d.getWindow().setBackgroundDrawableResource(R.drawable.dialog_box);
		d.setTitle("Add Field");
		
		final EditText ed = (EditText) d.findViewById(R.id.editText1);
		
		Button done = (Button) d.findViewById(R.id.button1);
		done.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				String fieldname = ed.getText().toString();
				if (fieldname.equals("")) {
					Toast.makeText(getApplicationContext(), "FieldName shouldnt empty!", Toast.LENGTH_SHORT).show();
				}
				else {

					TextView view = new TextView(AddDatabase.this);
					view.setText(fieldname);
					view.setTextSize(25);
					linearLayout.addView(view, layoutParams);
					fieldsArray.add(fieldname);
					d.cancel();

				}
			}
		});
		
		Button cancel = (Button) d.findViewById(R.id.button2);
		cancel.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				d.dismiss();
			}
		});
		
		d.show();
	}

	public void Done(View v) {
		CMS_Database myDatabase = new CMS_Database(this);
		myDatabase.openDatabase();
		myDatabase.create_table(tableName, fieldsArray);
		myDatabase.close();
		Toast.makeText(getApplicationContext(), "Table Created", Toast.LENGTH_SHORT).show();
		finish();
	}

}
