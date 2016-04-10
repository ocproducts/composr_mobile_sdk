package test.cms_utilities;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.ocproducts.composr.sdk.utilities.CMS_Database;

import android.test.AndroidTestCase;
import android.test.RenamingDelegatingContext;

public class CMS_Database_Test extends AndroidTestCase {

	private static final String TEST_FILE_PREFIX = "";
	private CMS_Database database;

	@Before
	public void setUp() throws Exception {
		super.setUp();
		RenamingDelegatingContext context = new RenamingDelegatingContext(
				getContext(), TEST_FILE_PREFIX);
		database = new CMS_Database(context);
		database.openDatabase();
	}

	@After
	public void tearDown() throws Exception {
		database.close();
		super.tearDown();
	}

	@Test
	public void testAdd_table_field() {
		String tableName = "testTable";

		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");
		database.create_table(tableName, fields);
		database.add_table_field(tableName, "field3");

		List<String> resultFields = database.getFieldNamesForTable(tableName);

		assertTrue("Field was not added", resultFields.contains("field3"));
		database.drop_table_if_exists(tableName);
	}

	@Test
	public void testRename_table_field() {
		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);
		database.rename_table_field(tableName, "field2", "field3");

		List<String> resultFields = database.getFieldNamesForTable(tableName);

		assertTrue("Field was not renamed.", resultFields.contains("field3"));
		assertFalse("Old field still exists.", resultFields.contains("field2"));
		assertTrue("Non renamed fields got deleted.",
				resultFields.contains("field1"));

		database.drop_table_if_exists(tableName);
	}

	@Test
	public void testDelete_table_field() {
		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);
		database.delete_table_field(tableName, "field2");

		List<String> resultFields = database.getFieldNamesForTable(tableName);

		assertFalse("Field was not deleted.", resultFields.contains("field2"));
		assertFalse("Oops. Where this field came from ??",
				resultFields.contains("field3"));
		assertTrue("Non deleted fields got deleted.",
				resultFields.contains("field1"));

		database.drop_table_if_exists(tableName);
	}

	@Test
	public void testCreate_table() {
		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);
		List<String> resultFields = database.getFieldNamesForTable(tableName);

		assertFalse("Table not created", resultFields.size() == 0);
		assertTrue("Not all fields added", resultFields.size() == 2);
		assertTrue("field1 not found in table", resultFields.get(0).toString()
				.equals("field1"));
		assertTrue("field2 not found in table", resultFields.get(1).toString()
				.equals("field2"));

		database.drop_table_if_exists(tableName);
	}

	@Test
	public void testDrop_table_if_exists() {
		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);
		List<String> resultFields = database.getFieldNamesForTable(tableName);
		assertFalse("Table not created. Then how will I check drop table ?",
				resultFields.size() == 0);
		assertTrue(
				"Not all fields added. So, create table went wrong. Please verify that first.",
				resultFields.size() == 2);

		database.drop_table_if_exists(tableName);

		resultFields = database.getFieldNamesForTable(tableName);
		assertTrue("Table still has fields. Hence not dropped. I fail..",
				resultFields.size() == 0);
	}

	@Test
	public void testDb_escape_string() {
		String inputString = "Hifi.. ' this is a ' test db' string..'''";
		String expectedOutput = "'Hifi.. '' this is a '' test db'' string..'''''''";
		String outputString = database.db_escape_string(inputString);

		assertTrue("I am not escaped..", outputString.equals(expectedOutput));

	}

	@Test
	public void testQuery() {
		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);

		HashMap<String, String> row1 = new HashMap<String, String>();
		row1.put("field1", "value11");
		row1.put("field2", "value12");

		HashMap<String, String> row2 = new HashMap<String, String>();
		row2.put("field1", "value21");
		row2.put("field2", "value22");

		// Just to cross check this unit works before testing this module
		testCreate_table();

		// Need to recreate the table as test_create_table will drop the table
		// after testing
		database.create_table(tableName, fields);
		database.query_insert(tableName, row1);
		database.query_insert(tableName, row2);

		String query = "select * from " + tableName + " where field1='value21'";
		List<Map<String, String>> queryResult = new ArrayList<Map<String, String>>();

		queryResult = database.query(query);

		assertTrue("I expect only a single field.", queryResult.size() == 1);

		assertTrue("", queryResult.get(0).get("field1").equals("value21"));
		assertTrue("", queryResult.get(0).get("field2").equals("value22"));

		database.drop_table_if_exists(tableName);
	}

	@Test
	public void testQuery_delete() {
		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);

		HashMap<String, String> row1 = new HashMap<String, String>();
		row1.put("field1", "value11");
		row1.put("field2", "value12");

		HashMap<String, String> row2 = new HashMap<String, String>();
		row2.put("field1", "value21");
		row2.put("field2", "value22");

		// Just to cross check this unit works before testing this module
		testCreate_table();

		// Need to recreate the table as test_create_table will drop the table
		// after testing

		database.create_table(tableName, fields);
		database.query_insert(tableName, row1);
		database.query_insert(tableName, row2);

		HashMap<String, String> deleteWhereMap = new HashMap<String, String>();
		deleteWhereMap.put("field2", "value22");

		database.query_delete(tableName, deleteWhereMap);
		String query = "select * from " + tableName;

		List<Map<String, String>> queryResult = new ArrayList<Map<String, String>>();
		queryResult = database.query(query);

		assertTrue("I expect only a single row as I have deleted the other.",
				queryResult.size() == 1);
		assertTrue("This is not the value I expect for field1", queryResult
				.get(0).get("field1").equals("value11"));
		assertTrue("This is not the value I expect for field2", queryResult
				.get(0).get("field2").equals("value12"));
		assertFalse("How come this field is here ? I had deleted this row.",
				queryResult.get(0).get("field1").equals("value21"));
		assertFalse("How come this field is here ? I had deleted this row.",
				queryResult.get(0).get("field2").equals("value22"));

		database.drop_table_if_exists(tableName);
	}

	@Test
	public void testQuery_insert() {
		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);

		HashMap<String, String> row1 = new HashMap<String, String>();
		row1.put("field1", "value11");
		row1.put("field2", "value12");

		HashMap<String, String> row2 = new HashMap<String, String>();
		row2.put("field1", "value21");
		row2.put("field2", "value22");

		// Just to cross check this unit works before testing this module
		testCreate_table();

		// Need to recreate the table as test_create_table will drop the table
		// after testing

		database.create_table(tableName, fields);
		database.query_insert(tableName, row1);
		database.query_insert(tableName, row2);

		String query = "select * from " + tableName;

		List<Map<String, String>> queryResult = new ArrayList<Map<String, String>>();
		queryResult = database.query(query);

		assertTrue("I had inserted 2. So, I want 2 rows here.",
				queryResult.size() == 2);

		assertTrue("This is not what I inserted for field1 in first row.",
				queryResult.get(0).get("field1").equals("value11"));
		assertTrue("This is not what I inserted for field2 in first row.",
				queryResult.get(0).get("field2").equals("value12"));

		assertTrue("This is not what I inserted for field1 in second row.",
				queryResult.get(1).get("field1").equals("value21"));
		assertTrue("This is not what I inserted for field2 in second row.",
				queryResult.get(1).get("field2").equals("value22"));

		database.drop_table_if_exists(tableName);

	}

	@Test
	public void testQuery_select() {
		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);

		HashMap<String, String> row1 = new HashMap<String, String>();
		row1.put("field1", "value11");
		row1.put("field2", "value12");

		HashMap<String, String> row2 = new HashMap<String, String>();
		row2.put("field1", "value21");
		row2.put("field2", "value22");

		// Just to cross check this unit works before testing this module
		testCreate_table();

		// Need to recreate the table as test_create_table will drop the table
		// after testing

		database.create_table(tableName, fields);
		database.query_insert(tableName, row1);
		database.query_insert(tableName, row2);

		List<String> selected = new ArrayList<String>();
		selected.add("field1");

		HashMap<String, String> whereMap = new HashMap<String, String>();
		whereMap.put("field2", "value22");

		List<Map<String, String>> queryResult = new ArrayList<Map<String, String>>();
		queryResult = database
				.query_select(tableName, selected, whereMap, null);

		// NSArray *queryResult = [CMS_Database query_select:tableName
		// :@[@"field1"] :@{@"field2":@"value22"} :nil];

		assertTrue(
				"My where condition should have selected one row. This is wrong..",
				queryResult.size() == 1);

		assertFalse("value11 shouldn't be here. How did it come ?", queryResult
				.get(0).get("field1").equals("value11"));
		assertFalse(
				"I haven't selected field2. Why did it come in the result ?",
				queryResult.contains("field2"));

		assertTrue("I need to get value21 here. But it's not.", queryResult
				.get(0).get("field1").equals("value21"));

		database.drop_table_if_exists(tableName);

	}

	@Test
	public void testQuery_select_value() {
		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);

		HashMap<String, String> row1 = new HashMap<String, String>();
		row1.put("field1", "value11");
		row1.put("field2", "value12");

		HashMap<String, String> row2 = new HashMap<String, String>();
		row2.put("field1", "value21");
		row2.put("field2", "value22");

		// Just to cross check this unit works before testing this module
		testCreate_table();

		// Need to recreate the table as test_create_table will drop the table
		// after testing

		database.create_table(tableName, fields);
		database.query_insert(tableName, row1);
		database.query_insert(tableName, row2);

		String selected = "field2";

		HashMap<String, String> whereMap = new HashMap<String, String>();
		whereMap.put("field1", "value11");

		String queryResult = database.query_select_value(tableName, selected,
				whereMap, null);

		String expectedResult = "value12";

		assertTrue("This is not what I had expected",
				queryResult.equals(expectedResult));
		assertFalse("This is not what I had expected",
				queryResult.equals("value22"));

		database.drop_table_if_exists(tableName);

	}

	@Test
	public void testQuery_select_int_value() {

		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);

		HashMap<String, String> row1 = new HashMap<String, String>();
		row1.put("field1", "value11");
		row1.put("field2", "12");

		HashMap<String, String> row2 = new HashMap<String, String>();
		row2.put("field1", "value21");
		row2.put("field2", "22");

		HashMap<String, String> row3 = new HashMap<String, String>();
		row3.put("field1", "value31");
		row3.put("field2", "32");

		// Just to cross check this unit works before testing this module
		testCreate_table();

		// Need to recreate the table as test_create_table will drop the table
		// after testing

		database.create_table(tableName, fields);
		database.query_insert(tableName, row1);
		database.query_insert(tableName, row2);
		database.query_insert(tableName, row3);

		HashMap<String, String> whereMap = new HashMap<String, String>();
		whereMap.put("field1", "value11");

		int queryResult = database.query_select_int_value(tableName, "field2",
				whereMap, null);
		
		int expectedResult = 12;

		assertTrue("This is not what I had expected",
				queryResult == expectedResult);

		queryResult = database.query_select_int_value(tableName, "field3",
				whereMap, null);

		expectedResult = -1;
		assertTrue(
				"I expect -1 if the field is not available or any error occured.",
				queryResult == expectedResult);

		HashMap<String, String> whereMap2 = new HashMap<String, String>();
		whereMap2.put("field1", "value21");

		queryResult = database.query_select_int_value(tableName, "field2",
				whereMap2, null);

		expectedResult = 22;
		assertTrue("This is not what I had expected",
				queryResult == expectedResult);

		database.drop_table_if_exists(tableName);
	}

	@Test
	public void testQuery_update() {
		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);

		HashMap<String, String> row1 = new HashMap<String, String>();
		row1.put("field1", "value11");
		row1.put("field2", "12");

		HashMap<String, String> row2 = new HashMap<String, String>();
		row2.put("field1", "value21");
		row2.put("field2", "value22");

		HashMap<String, String> row3 = new HashMap<String, String>();
		row3.put("field1", "value31");
		row3.put("field2", "value32");

		// Just to cross check this unit works before testing this module
		testCreate_table();

		// Need to recreate the table as test_create_table will drop the table
		// after testing

		database.create_table(tableName, fields);
		database.query_insert(tableName, row1);
		database.query_insert(tableName, row2);
		database.query_insert(tableName, row3);
		
		HashMap<String, String> valueMap=new HashMap<String, String>();
		valueMap.put("field2", "40");
		HashMap<String, String> whereMap=new HashMap<String, String>();
		whereMap.put("field1", "value31");
		database.query_update(tableName, valueMap, whereMap);
	    
		int queryResult=database.query_select_int_value(tableName, "field2", whereMap, null);
	    
	    int expectedResult = 40;
	    
	    assertTrue("I expect 40 here as I had updated it.", queryResult==expectedResult);
	    
	    HashMap<String, String> where=new HashMap<String, String>();
	    where.put("field1", "value11");
	    queryResult=database.query_select_int_value(tableName, "field2", where, null);
	    
	    expectedResult = 40;
	    assertTrue("I donot expect 40 here rather I want 12.", queryResult!=expectedResult&& queryResult==12);
	    
	    
	    database.drop_table_if_exists(tableName);
	}

	@Test
	public void testGetFieldNamesForTable() {
		
		String tableName = "testTable";
		List<String> fields = new ArrayList<String>();
		fields.add("field1");
		fields.add("field2");

		database.create_table(tableName, fields);
		
		List<String> fieldNames=new ArrayList<String>();
		fieldNames=database.getFieldNamesForTable(tableName);
	    
		assertTrue("I had made two fields. Where are they ?", fieldNames.size()==2);
		assertTrue("This is not my first field", fieldNames.get(0).toString().equals("field1"));
		assertTrue("This is not my second field", fieldNames.get(1).toString().equals("field2"));
		assertFalse("I haven't entered this kind of a field.", fieldNames.contains("field3"));

	    database.drop_table_if_exists(tableName);
	}


}