package com.example.cms_sdk_sample;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.ocproducts.composr.sdk.utilities.CMS_Database;

import android.app.Activity;
import android.app.AlertDialog;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class ViewTables extends Activity {
	List<Map<String, String>> data;
	ArrayList<String> resultNames;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.example_viewtable);
		
		CMS_Database db = new CMS_Database(this);
		db.openDatabase();
		
		String tabName = getIntent().getExtras().getString("name");

		data = db.query_select(tabName, null, null, null);
		resultNames = new ArrayList<String>();
		for (int i = 0; i < data.size(); i++) {
			resultNames.add(data.get(i).get(data.get(0).keySet().toArray()[0]));
		}

		ListView dataView = (ListView) findViewById(R.id.listview);
		ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.customtext, resultNames);

		dataView.setAdapter(adapter);

		dataView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				String values=data.get(arg2).toString();
				values=values.replace('{', ' ');
				values=values.replace('}', ' ');
				values=values.replace(',', '\n');
				AlertDialog.Builder builder = new AlertDialog.Builder(ViewTables.this);
				builder.setTitle("Details");
				builder.setMessage("" + values);
				builder.setIcon(android.R.drawable.ic_dialog_alert);
				builder.show();

			}
		});
	}

}
