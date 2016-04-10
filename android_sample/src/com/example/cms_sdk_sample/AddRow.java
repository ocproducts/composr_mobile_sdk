package com.example.cms_sdk_sample;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ocproducts.composr.sdk.utilities.CMS_Database;
import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.Toast;

public class AddRow extends Activity {

	LinearLayout.LayoutParams layoutParams;
	LinearLayout ll;
	String tableName;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.example_add_row);
		
		tableName = getIntent().getExtras().getString("name");
		
		ll = (LinearLayout) findViewById(R.id.fields);
		layoutParams = new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
		
		CMS_Database database = new CMS_Database(this);
		database.openDatabase();
		List<String> fieldNames = database.getFieldNamesForTable(tableName);
		database.close();
		
		for (String fieldName : fieldNames) {
			EditText view = new EditText(this);
			view.setText("");
			view.setHint(fieldName);
			view.setTextSize(25);
			ll.addView(view, layoutParams);
		}
	}
	
	public void Insert(View v) {
		Map<String, String> values = new HashMap<String, String>();
		for (int i=0; i<ll.getChildCount(); i++) {
			EditText view = (EditText) ll.getChildAt(i);
			values.put(view.getHint().toString(), view.getText().toString());
		}
		CMS_Database database = new CMS_Database(this);
		database.openDatabase();
		database.query_insert(tableName, values);
		database.close();
		Toast.makeText(this, "Values Inserted.", Toast.LENGTH_SHORT).show();
	}
	
}
