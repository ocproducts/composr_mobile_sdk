package com.example.cms_sdk_sample;

import com.ocproducts.composr.sdk.CMS_LoginActivity;
import com.ocproducts.composr.sdk.CMS_PasswordResetActivity;
import com.ocproducts.composr.sdk.rss.FeedListActivity;
import com.ocproducts.composr.sdk.utilities.NetworkManager;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        //initializing the CMS NetworkManager
        NetworkManager.createNewInstance("http://staging.ocproducts.com/");
        
        Button loginBtn = (Button)findViewById(R.id.loginBtn);
        loginBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				startActivity(new Intent(MainActivity.this, CMS_LoginActivity.class));
			}
		});
        
        Button signupBtn = (Button)findViewById(R.id.signupBtn);
        signupBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				startActivity(new Intent(MainActivity.this, SignUp.class));
			}
		});
        
        Button forgotPasswordBtn = (Button)findViewById(R.id.forgotPasswordBtn);
        forgotPasswordBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				startActivity(new Intent(MainActivity.this, CMS_PasswordResetActivity.class));
			}
		});
        
        Button feedBtn = (Button)findViewById(R.id.feedBtn);
        feedBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(MainActivity.this, FeedListActivity.class);
				intent.putExtra("url", "http://ocportal.com/backend.php?type=RSS2&mode=news&days=300&max=100&keep_session=1245593369");
				startActivity(intent);
			}
		}); 
        
        Button formBuilderBtn = (Button)findViewById(R.id.formBuilderBtn);
        formBuilderBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent ob = new Intent(MainActivity.this, Forms.class);
				startActivity(ob);
			}
		});
        
        Button databaseBtn = (Button)findViewById(R.id.databaseBtn);
        databaseBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent ob = new Intent(MainActivity.this, DBMainPage.class);
				startActivity(ob);
			}
		});
    }
}
