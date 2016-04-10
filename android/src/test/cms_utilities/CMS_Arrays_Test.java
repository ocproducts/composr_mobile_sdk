package test.cms_utilities;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;

import com.ocproducts.composr.sdk.utilities.CMS_Arrays;

public class CMS_Arrays_Test {

	@Test
	public final void testCollapse_1d_complexity() {
		HashMap<String, String> map1=new HashMap<String, String>();
		map1.put("demoval", "Testanswer1");
		map1.put("demoval2", "Testval1");

		HashMap<String, String> map2=new HashMap<String, String>();
		map2.put("demoval", "Testanswer2");
		map2.put("demoval2", "Testval2");
		
		List<Map<String, String>> arr=new ArrayList<Map<String,String>>();
		arr.add(map1);
		arr.add(map2);
		
		ArrayList<String> ansArray1=new ArrayList<String>();
		ansArray1.add("Testanswer1");
		ansArray1.add("Testanswer2");
		
		ArrayList<String> ansArray2=new ArrayList<String>();
		ansArray2.add("Testval1");
		ansArray2.add("Testval2");
	
		assertTrue(CMS_Arrays.collapse_1d_complexity("demoval", arr).equals(ansArray1));
		assertTrue(CMS_Arrays.collapse_1d_complexity("demoval2", arr).equals(ansArray2));
	}

	@Test
	public final void testCollapse_2d_complexity() {
		HashMap<String, String> map1=new HashMap<String, String>();
		map1.put("demoval", "Testanswer1");
		map1.put("demoval2", "Testval1");

		HashMap<String, String> map2=new HashMap<String, String>();
		map2.put("demoval", "Testanswer2");
		map2.put("demoval2", "Testval2");
		
		List<Map<String, String>> arr=new ArrayList<Map<String,String>>();
		arr.add(map1);
		arr.add(map2);
		
		Map<String, String> answerMap = new HashMap<String, String>();
		answerMap.put("Testanswer1", "Testval1");
		answerMap.put("Testanswer2", "Testval2");
	
		assertTrue(answerMap.equals(CMS_Arrays.collapse_2d_complexity("demoval", "demoval2", arr)));
	}

	@Test
	public final void testExplode() {
		List<String> explodeTest=new ArrayList<String>();
		explodeTest.add("This");
		explodeTest.add("is");
		explodeTest.add("a");
		explodeTest.add("demo");
		explodeTest.add("String");
		assertTrue(explodeTest.equals(CMS_Arrays.explode("-", "This-is-a-demo-String")));
	}

	@Test
	public final void testImplode() {
		assertTrue("This-is-a-demo-String".equals(CMS_Arrays.implode("-", CMS_Arrays.explode("-", "This-is-a-demo-String"))));
	}

	@Test
	public final void testIn_arrayStringListOfString() {
		List<String> inputArray = new ArrayList<String>();
		inputArray.add("test1");
		inputArray.add("test2");
		
		assertTrue(CMS_Arrays.in_array("test1", inputArray));
		assertFalse(CMS_Arrays.in_array("test3", inputArray));
	}

	@Test
	public final void testIn_arrayFloatListOfFloat() {
		List<Float> inputArray = new ArrayList<Float>();
		inputArray.add(3.5f);
		inputArray.add(4.2f);
		
		assertTrue(CMS_Arrays.in_array(4.2f, inputArray));
		assertFalse(CMS_Arrays.in_array(1.2f, inputArray));
	}

	@Test
	public final void testIn_arrayIntegerListOfInteger() {
		List<Integer> inputArray = new ArrayList<Integer>();
		inputArray.add(3);
		inputArray.add(4);
		
		assertTrue(CMS_Arrays.in_array(4, inputArray));
		assertFalse(CMS_Arrays.in_array(1, inputArray));
	}

	@Test
	public final void testArray_merge() {
		List<String> input1 = new ArrayList<String>();
		input1.add("test1");
		input1.add("test2");

		List<String> input2 = new ArrayList<String>();
		input2.add("test3");
		input2.add("test4");
		
		List<String> expectedOutput = new ArrayList<String>();
		expectedOutput.add("test1");
		expectedOutput.add("test2");
		expectedOutput.add("test3");
		expectedOutput.add("test4");
		
		List<String> wrongOutput = new ArrayList<String>();
		wrongOutput.add("test1");
		wrongOutput.add("test2");
		wrongOutput.add("test3");
		
		assertTrue(expectedOutput.equals(CMS_Arrays.array_merge(input1, input2)));
		assertFalse(wrongOutput.equals(CMS_Arrays.array_merge(input1, input2)));
		assertTrue(input1.equals(CMS_Arrays.array_merge(input1, null)));
		assertTrue(input2.equals(CMS_Arrays.array_merge(null, input2)));
	}

	@Test
	public final void testArray_key_exists() {
		HashMap<String, String> inputMap = new HashMap<String, String>();
		inputMap.put("demoval", "Testanswer2");
		inputMap.put("demoval2", "Testval2");
		
		assertTrue(CMS_Arrays.array_key_exists("demoval", inputMap));
		assertTrue(CMS_Arrays.array_key_exists("demoval2", inputMap));
		assertFalse(CMS_Arrays.array_key_exists("demoval3", inputMap));
	}

	@Test
	public final void testArray_unique() {
		List<String> input = new ArrayList<String>();
		input.add("test1");
		input.add("test2");
		input.add("test2");
		input.add("test3");

		List<String> expectedOutput = new ArrayList<String>();
		expectedOutput.add("test1");
		expectedOutput.add("test2");
		expectedOutput.add("test3");

		List<String> wrongOutput = new ArrayList<String>();
		wrongOutput.add("test1");
		wrongOutput.add("test2");
		wrongOutput.add("test2");
		wrongOutput.add("test3");
		
		List<String> output = CMS_Arrays.array_unique(input);
		assertTrue(output.size() == 3);
		assertFalse(output.size() == 4);
		assertTrue(output.contains("test1"));
		assertTrue(output.contains("test2"));
		assertTrue(output.contains("test3"));
	}

	@Test
	public final void testSort_maps_by() {
		List<Map<String,String>> inputArray = new ArrayList<Map<String,String>>();
		Map<String,String> map1 = new HashMap<String, String>();
		map1.put("id", "0");
		map1.put("name", "test");
		Map<String,String> map2 = new HashMap<String, String>();
		map2.put("id", "5");
		map2.put("name", "test5");
		Map<String,String> map3 = new HashMap<String, String>();
		map3.put("id", "2");
		map3.put("name", "test2");
		Map<String,String> map4 = new HashMap<String, String>();
		map4.put("id", "1");
		map4.put("name", "test1");
		inputArray.add(map1);
		inputArray.add(map2);
		inputArray.add(map3);
		inputArray.add(map4);
		
		CMS_Arrays.sort_maps_by(inputArray, "id");
		
		assertTrue(inputArray.get(1).get("id").equals("1"));
		assertTrue(inputArray.get(1).get("name").equals("test1"));
		assertTrue(inputArray.get(3).get("id").equals("5"));
		assertTrue(inputArray.get(3).get("name").equals("test5"));
	}

	@Test
	public final void testSort() {
		List<String> inputList1 = new ArrayList<String>();
		inputList1.add("5");
		inputList1.add("3");
		inputList1.add("1");
		inputList1.add("6");
		inputList1.add("2");
		
		List<String> expectedCorrectOutput1 = new ArrayList<String>();
		expectedCorrectOutput1.add("1");
		expectedCorrectOutput1.add("2");
		expectedCorrectOutput1.add("3");
		expectedCorrectOutput1.add("5");
		expectedCorrectOutput1.add("6");
		
		List<String> expectedCorrectOutput2 = new ArrayList<String>();
		expectedCorrectOutput2.add("6");
		expectedCorrectOutput2.add("5");
		expectedCorrectOutput2.add("3");
		expectedCorrectOutput2.add("2");
		expectedCorrectOutput2.add("1");
		
		List<String> expectedCorrectOutput3 = new ArrayList<String>();
		expectedCorrectOutput3.add("5");
		expectedCorrectOutput3.add("3");
		expectedCorrectOutput3.add("1");
		expectedCorrectOutput3.add("6");
		expectedCorrectOutput3.add("2");
		
		CMS_Arrays.sort(inputList1);
		
		assertTrue(inputList1.equals(expectedCorrectOutput1));
		assertFalse(inputList1.equals(expectedCorrectOutput2));
		assertFalse(inputList1.equals(expectedCorrectOutput3));
		
		List<Integer> inputList2 = new ArrayList<Integer>();
		inputList2.add(5);
		inputList2.add(3);
		inputList2.add(1);
		inputList2.add(6);
		inputList2.add(2);
		
		CMS_Arrays.sort(inputList2);
		
		List<Integer> expectedCorrectOutput21 = new ArrayList<Integer>();
		expectedCorrectOutput21.add(1);
		expectedCorrectOutput21.add(2);
		expectedCorrectOutput21.add(3);
		expectedCorrectOutput21.add(5);
		expectedCorrectOutput21.add(6);
		
		List<Integer> expectedCorrectOutput22 = new ArrayList<Integer>();
		expectedCorrectOutput22.add(6);
		expectedCorrectOutput22.add(5);
		expectedCorrectOutput22.add(3);
		expectedCorrectOutput22.add(2);
		expectedCorrectOutput22.add(1);
		
		List<Integer> expectedCorrectOutput23 = new ArrayList<Integer>();
		expectedCorrectOutput23.add(5);
		expectedCorrectOutput23.add(3);
		expectedCorrectOutput23.add(1);
		expectedCorrectOutput23.add(6);
		expectedCorrectOutput23.add(2);
		
		assertTrue(inputList2.equals(expectedCorrectOutput21));
		assertFalse(inputList2.equals(expectedCorrectOutput22));
		assertFalse(inputList2.equals(expectedCorrectOutput23));
	}

	@Test
	public final void testCountList() {
		List<String> inputList1 = new ArrayList<String>();
		inputList1.add("5");
		inputList1.add("3");
		inputList1.add("1");
		inputList1.add("6");
		inputList1.add("2");
		
		assertTrue(CMS_Arrays.count(inputList1) == 5);
		assertFalse(CMS_Arrays.count(inputList1) == 4);
	}

	@Test
	public final void testCountMap() {
		HashMap<String, String> inputMap=new HashMap<String, String>();
		inputMap.put("demoval", "Testanswer1");
		inputMap.put("demoval2", "Testval1");
		inputMap.put(null, "Testval2");
		
		assertTrue(CMS_Arrays.count(inputMap) == 3);
		assertFalse(CMS_Arrays.count(inputMap) == 2);
		assertTrue(CMS_Arrays.count(new HashMap<String, Integer>()) == 0);
	}
	
	@Test
	public final void testList_to_map() {
		List<Map<String,String>> inputList = new ArrayList<Map<String,String>>();
		Map<String, String> inputMap1 = new HashMap<String, String>();
		inputMap1.put("id", "1");
		inputMap1.put("val", "val1");
		Map<String, String> inputMap2 = new HashMap<String, String>();
		inputMap2.put("id", "2");
		inputMap2.put("val", "val2");
		inputList.add(inputMap1);
		inputList.add(inputMap2);
		
		Map<String, Map<String, String>> expectedOutput = new HashMap<String, Map<String,String>>();
		expectedOutput.put("1", inputMap1);
		expectedOutput.put("2", inputMap2);
		
		assertTrue(expectedOutput.equals(CMS_Arrays.list_to_map("id", inputList)));
	}
	
	@Test
	public final void testArray_values() {
		Map<String, String> inputMap = new HashMap<String, String>();
		inputMap.put("id", "1");
		inputMap.put("val", "val1");
		
		List<String> expectedOutput1 = new ArrayList<String>();
		expectedOutput1.add("val");
		expectedOutput1.add("id");

		List<String> expectedOutput2 = new ArrayList<String>();
		expectedOutput2.add("val1");
		expectedOutput2.add("1");
		
		assertTrue(expectedOutput1.equals(CMS_Arrays.Array_values(true, inputMap)));
		assertTrue(expectedOutput2.equals(CMS_Arrays.Array_values(false, inputMap)));
	}
}
