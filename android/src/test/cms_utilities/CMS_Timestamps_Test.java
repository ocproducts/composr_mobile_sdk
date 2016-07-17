package test.cms_utilities;

import static org.junit.Assert.*;

import org.junit.Test;

import com.ocproducts.composr.sdk.utilities.CMS_Timestamps;

public class CMS_Timestamps_Test {

	@Test
	public void testGet_timezoned_date() {
		long timestamp = 1454978639751l;
		
	    String expectedOutput = "Feb 09, 2016 - 06:13:59";
	    
	    System.out.println(CMS_Timestamps.get_timezoned_date_time(timestamp));
	    assertTrue(expectedOutput.equals(CMS_Timestamps.get_timezoned_date_time(timestamp)));
	    
	    String expectedOutputWithoutTime = "Feb 09, 2016";
	    assertTrue(expectedOutputWithoutTime.equals(CMS_Timestamps.get_timezoned_date(timestamp)));
	}

}
