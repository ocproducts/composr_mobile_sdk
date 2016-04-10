package com.ocproducts.composr.sdk.utilities;

import java.util.Map;

import android.content.Context;

public class NetworkManager {
	
	static {
		NetworkManager.createNewInstance();
	}
	
	static NetworkManager instance;
	public static NetworkManager sharedManager(String baseUrl) {
		if (instance != null) {
			return instance;
		}
		instance = new NetworkManager(baseUrl);
		return instance;
	}
	
	public static NetworkManager sharedManager() {
		return NetworkManager.sharedManager(null);
	}
	
	public static NetworkManager createNewInstance(String baseUrl) {
		return NetworkManager.sharedManager(baseUrl);
	}
	
	public static NetworkManager createNewInstance() {
		return NetworkManager.createNewInstance(null);
	}
	
	private String baseUrl;
	
	private NetworkManager(String baseUrl) {
		if (baseUrl == null || baseUrl.trim().equals("")) {
			this.baseUrl = Constants.BASE_URL;
		} else {
			this.baseUrl = baseUrl;
		}
	}

	public String getBaseUrl() {
		return baseUrl;
	}

	public void setBaseUrl(String baseUrl) {
		this.baseUrl = baseUrl;
	}
	
	public void executeRequest(String url, boolean triggerError, Map<String, String> postParams, Map<String, String> headers, int timeoutInSeconds, Context context) {
		new CMS_AsyncTask(baseUrl+url, triggerError, postParams, headers, timeoutInSeconds, context).execute();
	}

}
