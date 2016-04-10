package test.cms_utilities;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import com.ocproducts.composr.sdk.utilities.CMS_Preferences;
import com.ocproducts.composr.sdk.utilities.CMS_Users;
import com.ocproducts.composr.sdk.utilities.Constants;

import android.content.Context;
import android.test.InstrumentationTestCase;

public class CMS_Users_Test extends InstrumentationTestCase {
	
	Context context;
	
	@Before
	public void setUp() throws Exception {
		super.setUp();
		context = getInstrumentation().getContext();
		
		CMS_Preferences.set_value(Constants.k_MemberID, 121, context);
		CMS_Preferences.set_value(Constants.k_User_PagesBlacklist, "page1,page2", context);
		CMS_Preferences.set_value(Constants.k_User_Privileges, "privilege1,privilege2", context);
		CMS_Preferences.set_value(Constants.k_User_Zones, "zone1,zone2", context);
		CMS_Preferences.set_value(Constants.k_isStaff, true, context);
		CMS_Preferences.set_value(Constants.k_isSuperAdmin, true, context);
		CMS_Preferences.set_value(Constants.k_SessionID, 252, context);
		CMS_Preferences.set_value(Constants.k_Username, "testUser", context);
		CMS_Preferences.set_value(Constants.k_Password, "testPass", context);
		CMS_Preferences.set_value(Constants.k_Members_Groups, "name:group1;type:testType;,name:group2;type:testType;", context);
	}

	@Test
	public void testHas_page_access() {
		Assert.assertTrue(CMS_Users.has_page_access(context, "page3"));
		Assert.assertFalse(CMS_Users.has_page_access(context, "page2"));
	}

	@Test
	public void testHas_privilege() {
		assertTrue(CMS_Users.has_privilege("privilege1", context));
		assertTrue(CMS_Users.has_privilege("privilege2", context));
		assertFalse(CMS_Users.has_privilege("privilege3", context));
	}

	@Test
	public void testHas_zone_access() {
		assertTrue(CMS_Users.has_zone_access("zone1", context));
		assertTrue(CMS_Users.has_zone_access("zone2", context));
		assertFalse(CMS_Users.has_zone_access("zone3", context));
	}

	@Test
	public void testIs_staff() {
		assertTrue(CMS_Users.is_staff(context));
	}

	@Test
	public void testIs_super_admin() {
		assertFalse(CMS_Users.is_super_admin(context));
	}

	@Test
	public void testGet_member() {
		assertTrue(CMS_Users.get_member(context) == 121);
	}

	@Test
	public void testGet_session_id() {
		assertTrue(CMS_Users.get_session_id(context) == 252);
	}

	@Test
	public void testGet_username() {
		assertTrue(CMS_Users.get_username(context).equals("testUser"));
	}

	@Test
	public void testGet_member_groups() {
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		Map<String, String> map1 = new HashMap<String, String>();
		map1.put("name", "group1");
		map1.put("type", "testType");
		Map<String, String> map2 = new HashMap<String, String>();
		map2.put("name", "group2");
		map2.put("type", "testType");
		list.add(map1);
		list.add(map2);
		
		assertTrue(CMS_Users.get_member_groups(context).equals(list));
	}

	@Test
	public void testGet_members_groups_names() {
		List<String> list = new ArrayList<String>();
		list.add("group1");
		list.add("group2");
		assertTrue(CMS_Users.get_members_groups_names(context).equals(list));
	}

	@Test
	public void testGet_value() {
		assertTrue(CMS_Users.get_value(Constants.k_User_PagesBlacklist, context).equals("page1,page2"));
	}

	@Test
	public void testGet_password() {
		assertTrue(CMS_Users.get_password(context).equals("testPass"));
	}


}
