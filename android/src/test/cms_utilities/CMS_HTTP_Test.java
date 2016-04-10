package test.cms_utilities;

import org.junit.Test;

import java.util.HashMap;

import org.json.JSONException;
import org.json.JSONObject;

import com.ocproducts.composr.sdk.utilities.CMS_HTTP;
import com.ocproducts.composr.sdk.utilities.Constants;

import android.test.InstrumentationTestCase;

public class CMS_HTTP_Test extends InstrumentationTestCase  {

	@Test
	public void testJson_decode() {
		JSONObject obj = null;
		String jsonString = "{\"test\":\"val\",\"test1\":\"val1\"}";
		try {
			obj = CMS_HTTP.json_decode(jsonString);
		} catch (JSONException e) {
			e.printStackTrace();
		}

		JSONObject expectedOutput = new JSONObject();
		try {
			expectedOutput.put("test", "val");
			expectedOutput.put("test1", "val1");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		assertTrue(obj.toString().equals(expectedOutput.toString()));
	}

	@Test
	public void testJson_encode() {
		HashMap<String, String> inputDict = new HashMap<String, String>();
		inputDict.put("test", "val");
		inputDict.put("test1", "val1");
		JSONObject object = new JSONObject(inputDict);
		String expectedOutput = "{\"test1\":\"val1\",\"test\":\"val\"}";
		assertTrue(expectedOutput.equals(CMS_HTTP.json_encode(object)));
	}

	@Test
	public void testGet_base_url() {
		assertTrue(CMS_HTTP.get_base_url().equals(Constants.BASE_URL));
	}

	@Test
	public void testBuild_url() {
		HashMap<String, String> inputDict = new HashMap<String, String>();
		inputDict.put("test", "val");
		inputDict.put("test1", "val1");
	    
	    String outputUrl = CMS_HTTP.build_url(inputDict, "testZone");
	    
	    String expectedUrl = Constants.BASE_URL+"/testZone/index.php?&test1=val1&test=val";
	    assertTrue(outputUrl.equals(expectedUrl));
	}

}
