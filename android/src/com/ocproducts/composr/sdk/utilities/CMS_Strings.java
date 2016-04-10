package com.ocproducts.composr.sdk.utilities;

import java.util.Arrays;

import org.apache.commons.lang3.StringEscapeUtils;

/*

CMS_Strings

string strip_tags(string str) - remove all HTML tags from the input string
string html_entity_decode(string str) - convert common HTML entities to standard characters (e.g. "&amp;" becomes "&", "&ldquo;" becomes the unicode equivalent of that HTML entity)
string float_format(float number, int decimalPoints, bool onlyIncludeNeededDecimalPoints) - formats a number nicely (e.g. with commas and decimal points)
int strpos(string searchIn, string searchFor) - see the PHP manual
string str_replace(string search, string replace, string searchIn) - see the PHP manual
string substr(string searchIn, int offset, int length) - see the PHP manual
string trim(string str) - see the PHP manual

*/

public class CMS_Strings {

	public static String strip_tags(String str) {
	    String[] sArray = str.split("<[^>]+>");
	    return CMS_Arrays.implode("", Arrays.asList(sArray));
	}
	
	public static String html_entity_decode(String str) {
		return StringEscapeUtils.unescapeHtml4(str);
	}
	
	public static String float_format(double number, int decimalPoints, boolean onlyIncludeNeededDecimalPoints) {
		String format = "%f";
		if (onlyIncludeNeededDecimalPoints) {
			format = "%." + decimalPoints + "f"; 
		}
		return String.format(format, number);
	}
	
	public static int strpos(String searchIn, String searchFor) {
		return searchIn.indexOf(searchFor);
	}
	
	public static String str_replace(String search, String replace, String searchIn) {
		return searchIn.replace(search, replace);
	}
	
	public static String substr(String searchIn, int offset, int length) {
		return searchIn.substring(offset, offset+length);
	}
	
	public static String trim(String str) {
		return str.trim();
	}
}
