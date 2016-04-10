package com.example.cms_sdk_sample;

import com.ocproducts.composr.sdk.rss.FeedListActivity;

import com.ocproducts.composr.sdk.CMS_LoginActivity;
import com.ocproducts.composr.sdk.CMS_PasswordResetActivity;
import com.ocproducts.composr.sdk.CMS_SignupActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

public class DBOperationsExample extends Activity{
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.example_db_operations);
		
	}
	
	public void DatabaseOps(View v) {
		Intent ob=new Intent(this, DBMainPage.class);
		startActivity(ob);
	}
	public void LoginAction(View v) {
		Intent ob=new Intent(this, CMS_LoginActivity.class);
		startActivity(ob);
	}
	
	public void SingupAction(View v) {
		Intent ob=new Intent(this, CMS_SignupActivity.class);
		startActivity(ob);
	}
	
	public void GetFeedz(View v) {
		Intent ob=new Intent(this, FeedListActivity.class);
		startActivity(ob);
	}
	
	public void ForgotPassword(View v) {
		Intent ob=new Intent(this, CMS_PasswordResetActivity.class);
		startActivity(ob);
	}

}
