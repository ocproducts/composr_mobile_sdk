package test.cms_utilities;

import junit.framework.Assert;

import org.junit.Test;

import com.ocproducts.composr.sdk.utilities.CMS_Preferences;

import android.test.InstrumentationTestCase;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;

public class CMS_Preferences_Test extends InstrumentationTestCase {

	@Test
	public void testGet_value() {
		
		SharedPreferences preferences=PreferenceManager.getDefaultSharedPreferences(getInstrumentation().getContext());
		Editor testEdit=preferences.edit();
	    String testKey = "myTestKey";
	    String testVal = "myTestVal";
	    testEdit.putString(testKey, "myTestVal");
	    testEdit.commit();
	    
	    Assert.assertTrue(CMS_Preferences.get_value(testKey, getInstrumentation().getContext()).equals(testVal));
	    
	    testEdit.clear();
	    testEdit.commit();
	    
	}

	@Test
	public void testSet_value() {
		String testKey = "myTestKey";
	    String testVal = "myTestVal";	
	    
	    CMS_Preferences.set_value(testKey, testVal, getInstrumentation().getContext());
	    Assert.assertTrue(CMS_Preferences.get_value(testKey, getInstrumentation().getContext()).equals(testVal));
	}

}
