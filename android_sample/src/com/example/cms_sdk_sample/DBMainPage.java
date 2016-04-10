package com.example.cms_sdk_sample;

import com.ocproducts.composr.sdk.utilities.CMS_Database;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class DBMainPage extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.example_dbmain);
	}

	public void CreateTable(View v) {
		final Dialog d = new Dialog(DBMainPage.this);
		d.requestWindowFeature(Window.FEATURE_NO_TITLE);
		d.setContentView(R.layout.example_db_dialog);

		d.getWindow().setBackgroundDrawableResource(R.drawable.dialog_box);
		d.setTitle("Create Table");
		final EditText ed = (EditText) d.findViewById(R.id.edit);
		
		Button done = (Button) d.findViewById(R.id.button1);
		done.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				String tabName=ed.getText().toString();
				Intent ob = new Intent(DBMainPage.this, AddDatabase.class);
				ob.putExtra("name", ""+tabName);
				startActivity(ob);
				d.dismiss();
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
	
	public void ViewTables(View v) {
		final Dialog d = new Dialog(DBMainPage.this);
		d.requestWindowFeature(Window.FEATURE_NO_TITLE);
		d.setContentView(R.layout.example_db_dialog);
		d.getWindow().setBackgroundDrawableResource(R.drawable.dialog_box);
		
		final TextView title = (TextView) d.findViewById(R.id.textView2);
		title.setText("View Data");
		
		final EditText ed = (EditText) d.findViewById(R.id.edit);
		
		Button done = (Button) d.findViewById(R.id.button1);
		done.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				CMS_Database cDatabase=new CMS_Database(DBMainPage.this);
                cDatabase.openDatabase();
                
				String tableName=ed.getText().toString();
                if (!tableName.equals("")) {
                    if(!cDatabase.isTableExists(tableName, true)) {
                        Toast.makeText(getApplicationContext(), "Table Doesn't Exist !!", Toast.LENGTH_SHORT).show();
                    } else {
                        Intent viewIntent=new Intent(getApplicationContext(), ViewTables.class);
                        viewIntent.putExtra("name", tableName);
                        startActivity(viewIntent);
                        d.dismiss();
                    }
                }
                else{
                    Toast.makeText(getApplicationContext(), "Table name must not be empty!", Toast.LENGTH_SHORT).show();
                }
                cDatabase.close();
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
	 
	public void DeleteTable(View v) {
		final Dialog d = new Dialog(DBMainPage.this);
		d.requestWindowFeature(Window.FEATURE_NO_TITLE);
		d.setContentView(R.layout.example_db_dialog);
		
		final TextView title = (TextView) d.findViewById(R.id.textView2);
		title.setText("Delete Table");

		d.getWindow().setBackgroundDrawableResource(R.drawable.dialog_box);
		
		final EditText ed = (EditText) d.findViewById(R.id.edit);
		
		Button done = (Button) d.findViewById(R.id.button1);
		done.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				CMS_Database cDatabase=new CMS_Database(DBMainPage.this);
				cDatabase.openDatabase();
				
				String tableName=ed.getText().toString();
				if (!tableName.equals("")) {
					if(!cDatabase.isTableExists(tableName, true)) {
						Toast.makeText(getApplicationContext(), "Table Doesn't Exist !!", Toast.LENGTH_SHORT).show();
					} else {
						cDatabase.drop_table_if_exists(tableName);	
						d.dismiss();
						Toast.makeText(getApplicationContext(), "Table Deleted!", Toast.LENGTH_SHORT).show();
					}
				}
				else{
					Toast.makeText(getApplicationContext(), "Table name must not be empty!", Toast.LENGTH_SHORT).show();
				}
				
				cDatabase.close();
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
	
	public void AddRow(View v) {
		final Dialog d = new Dialog(DBMainPage.this);
		d.requestWindowFeature(Window.FEATURE_NO_TITLE);
		d.setContentView(R.layout.example_db_dialog);
		
		final TextView title = (TextView) d.findViewById(R.id.textView2);
		title.setText("Insert Data");

		d.getWindow().setBackgroundDrawableResource(R.drawable.dialog_box);

		final EditText ed = (EditText) d.findViewById(R.id.edit);
		
		Button done = (Button) d.findViewById(R.id.button1);
		done.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				CMS_Database cDatabase=new CMS_Database(DBMainPage.this);
                cDatabase.openDatabase();
                
                String tableName=ed.getText().toString();
                if (!tableName.equals("")) {
                    if(!cDatabase.isTableExists(tableName, true)) {
                        Toast.makeText(getApplicationContext(), "Table Doesn't Exist !!", Toast.LENGTH_SHORT).show();
                    } else {
                        Intent viewIntent=new Intent(getApplicationContext(), AddRow.class);
                        viewIntent.putExtra("name", tableName);
                        startActivity(viewIntent);
                        d.dismiss();
                    }
                }
                else{
                    Toast.makeText(getApplicationContext(), "Table name must not be empty!", Toast.LENGTH_SHORT).show();
                }
                cDatabase.close();
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

}
