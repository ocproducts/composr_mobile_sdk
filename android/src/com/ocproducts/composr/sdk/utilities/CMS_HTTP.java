package com.ocproducts.composr.sdk.utilities;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.json.JSONException;
import org.json.JSONObject;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.util.Log;
import android.widget.Toast;

/*

CMS_HTTP

string rawurlencode(string str) - see the PHP manual
object json_decode(string value) - see the PHP manual
string json_encode(object value) - see the PHP manual
string get_base_url - gets base URL to ocPortal site, defined for the project in a string resource of constant
string build_url(map params, string zone) - creates <base_url>/<zone>/index.php?<params...>
string http_download_file(string url, bool triggerError, map postParams, int timeoutInSeconds) - if triggerError is true, a failure will show a generic error alert. If postParams is not null/nil then it will be an HTTP post.
bool has_network_connection() - base the code on what we use for Fishin' Mobile, but make sure it is generic

*/

public class CMS_HTTP {

	public static String rawurlencode(String str) {
		try {
			return URLEncoder.encode(str, "utf-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return str;
	}
	
	public static JSONObject json_decode(String value) throws JSONException {
		return new JSONObject(value);
	}
	
	public static String json_encode(JSONObject value) {
		return value.toString();
	}
	
	public static String get_base_url() {
		return Constants.BASE_URL;
	}
	
	public static String build_url(Map<String, String> params, String zone) {
		StringBuilder sb = new StringBuilder();
		sb.append(CMS_HTTP.get_base_url());
		sb.append("/" + zone + "/index.php?");
		for (String key : params.keySet()) {
			sb.append("&" + key + "=" + params.get(key));
		}
	    return sb.toString();
	}
	
	public static String http_download_file(String url, boolean triggerError, Map<String, String> postParams, int timeoutInSeconds, final Activity context) {
		return http_download_file(url, triggerError, postParams, null, timeoutInSeconds, context);
	}
	
	public static String http_download_file(String url, boolean triggerError, Map<String, String> postParams, Map<String, String> headers, int timeoutInSeconds, final Activity context) {
		String result = null;

        try {
            final HttpClient httpClient = new DefaultHttpClient();
            final HttpPost httpPost = new HttpPost(url);
            HttpParams httpParameters = new BasicHttpParams();

            int timeout = timeoutInSeconds * 1000; //convert seconds to milliseconds
            HttpConnectionParams.setSoTimeout(httpParameters, timeout);
            HttpConnectionParams.setConnectionTimeout(httpParameters, timeout);
            Timer timer = new Timer();
            timer.schedule(new TimerTask() {
                public void run()
                {
                    if (httpPost != null) {
                        httpPost.abort();
                    }
                }
            }, timeout);

            if (postParams != null) {
                ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
                for (String name : postParams.keySet()) {
    				nameValuePairs.add(new BasicNameValuePair(name, postParams.get(name)));
    			}
                httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs, "UTF-8"));

                if (Constants.DEBUG_MODE)
                    Log.i("CMS_SDK", "Params: " + nameValuePairs);
			}

            if (headers != null) {
                for (String name : headers.keySet()) {
                	httpPost.addHeader(name, headers.get(name));
    			}

                if (Constants.DEBUG_MODE)
                    Log.i("CMS_SDK", "Headers: " + headers);
			}

            Log.i("CMS_SDK", "URL: " + url);

            HttpResponse response = httpClient.execute(httpPost);

            result = convertStreamToString(response.getEntity().getContent());
        }
        catch (IOException e) {
            if (triggerError && context != null && context instanceof Activity) {
                context.runOnUiThread(new Runnable() {
                    @Override
                    public void run()
                    {
                        Toast.makeText(context, "Internet connection error! Please try again.", Toast.LENGTH_LONG).show();
                    }
                });
            }
            e.printStackTrace();
        }

        return result;
	}
	
	static String convertStreamToString(java.io.InputStream is) {
	    @SuppressWarnings("resource")
		java.util.Scanner s = new java.util.Scanner(is, "UTF-8").useDelimiter("\\A");
	    return s.hasNext() ? s.next() : "";
	}
	
	public static boolean has_network_connection(Context context) {
		ConnectivityManager conMgr = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);

		if (Constants.DEBUG_MODE && Constants.WORK_OFFLINE)
            return false;
		
        // Are we connected to the Internet?
        if (conMgr.getActiveNetworkInfo() != null && conMgr.getActiveNetworkInfo().isAvailable() && conMgr.getActiveNetworkInfo().isConnected()) {
            return true;
        }
        else {
            return false;
        }
	}
	
	public static <T> T fromJson(final TypeReference<T> type, final String jsonString) throws JsonParseException, JsonMappingException, IOException {
		T data = new ObjectMapper().readValue(jsonString, type);
		return data;
	}
}
