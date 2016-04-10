package test.cms_utilities;

import static org.junit.Assert.*;

import org.junit.Test;

import com.ocproducts.composr.sdk.utilities.CMS_Strings;

public class CMS_Strings_Test {

	@Test
	public void testStrip_tags() {
		assertEquals("Output string as expected", "test", CMS_Strings.strip_tags("<head>test<head>"));
	}

	@Test
	public void testHtml_entity_decode() {
		String htmlString="&lt;h1&gt;Main Title&lt;/h1&gt;";
		String outputString="<h1>Main Title</h1>";
		System.out.println(CMS_Strings.html_entity_decode(htmlString));
		assertEquals("Output string as expected", outputString, CMS_Strings.html_entity_decode(htmlString));
	}

	@Test
	public void testFloat_format() {
		assertEquals("Output Float as expected", "1234.56", CMS_Strings.float_format(1234.564, 2, true));
		assertEquals("Output Float as expected", "1234.56400", CMS_Strings.float_format(1234.56400, 5, true));
	}

	@Test
	public void testStrpos() {
		assertEquals("Output index as expected", 6, CMS_Strings.strpos("TestString", "r"));
	}

	@Test
	public void testStr_replace() {
		assertEquals("Output string as expected", "this will be success", CMS_Strings.str_replace("test", "success", "this will be test"));
	}

	@Test
	public void testSubstr() {
		assertEquals("Output string as expected", "sts", CMS_Strings.substr("teststring", 2, 3));
	}

	@Test
	public void testTrim() {
		assertEquals("Output string as expected", "teststring", CMS_Strings.trim("teststring     "));
	}

}
