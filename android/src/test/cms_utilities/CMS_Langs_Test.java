package test.cms_utilities;

import junit.framework.Assert;

import org.junit.Test;

import com.ocproducts.composr.sdk.utilities.CMS_Langs;

import android.test.InstrumentationTestCase;

public class CMS_Langs_Test extends InstrumentationTestCase {

	@Test
	public void testDo_lang() {
		String expectedString = "This is an example string";
	    String inputString = "EXAMPLE_STRING";
	    Assert.assertTrue(CMS_Langs.do_lang(inputString, getInstrumentation().getContext()).equals(expectedString));
	}

}
