package com.ocproducts.composr.sdk.utilities;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

/*

CMS_Arrays

array collapse_1d_complexity(string key, array arr) - takes a list of maps and turns it into a simple list by extracting just one element from each map
map collapse_2d_complexity(string keyKey, string valKey, array arr) - takes a list of maps and turns it into a simple map by extracting just two elements from each map
array explode(string sep, string str) - see the PHP manual
string implode(string sep, array arr) - see the PHP manual

*/
@SuppressWarnings({"unchecked","rawtypes"})
public class CMS_Arrays {
	
	public static List<String> collapse_1d_complexity(String key, List<Map<String, String>> arr) {
		ArrayList<String> array = new ArrayList<String>();
		for (Map<String,String> hashMap : arr) {
			String val = hashMap.get(key);
			if (val != null) {
				array.add(val);
			}
		}
		return array;
	}
	
	public static Map<String, String> collapse_2d_complexity(String keyKey, String valKey, List<Map<String, String>> arr) {
		HashMap<String, String> map = new HashMap<String, String>();
		for (Map<String,String> hashMap : arr) {
			String key = hashMap.get(keyKey);
			String val = hashMap.get(valKey);
			if (key != null && val != null) {
				map.put(key, val);
			}
		}
		return map;
	}
	
	public static List<String> explode(String sep, String str) {
		return Arrays.asList(str.split(sep));
	}
	
	public static String implode(String sep, List<String> arr) {
		StringBuilder sb = new StringBuilder();
	    Iterator<?> iter = arr.iterator();
	    if (iter.hasNext())
	        sb.append(iter.next().toString());
	    while (iter.hasNext()) {
	        sb.append(sep);
	        sb.append(iter.next().toString());
	    }
	    return sb.toString();
	}
	
	public static String mapToString(Map<String, String> map) {
		if (map == null || map.isEmpty()) {
			return "";
		}
		Set<String> keySet = map.keySet();
		if (keySet.isEmpty()) {
			return "";
		}
		ArrayList<String> mapElements = new ArrayList<String>();
		for (String key : map.keySet()) {
			mapElements.add(key + ":" + map.get(key));
		}
		return CMS_Arrays.implode(";", mapElements);
	}
	
	public static Map<String, String> stringToMap(String mapString) {
		List<String> mapElements = CMS_Arrays.explode(";", mapString);
		HashMap<String, String> map = new HashMap<String, String>();
		for (String string : mapElements) {
			String[] keyValuePair = string.split(":");
			if (keyValuePair != null && keyValuePair.length < 2) {
				continue;
			}
			map.put(keyValuePair[0], keyValuePair[1]);
		}
		return map;
	}
	
	public static boolean in_array(String key, List<String> array) {
		if(array!=null && array.size()>0) {
			for(String string:array) {
				if(string.equals(key)) {
					return true;
				}
			}
		}
		return false;
	}
	
	public static boolean in_array(Float key, List<Float> array) {
		if(array!=null && array.size()>0) {
			for(Float floatValue:array) {
				if(floatValue.equals(key)) {
					return true;
				}
			}
		}
		return false;
	}
	
	public static boolean in_array(Integer key, List<Integer> array) {
		if(array!=null && array.size()>0) {
			for(Integer integer:array) {
				if(integer.equals(key)) {
					return true;
				}
			}
		}
		return false;
	}
	
	public static <T> List<T> array_merge(List<T> array1, List<T> array2) {
		if(array1 !=null && array1.size()>0 && array2!=null && array2.size()>0) {
			array1.addAll(array2);
			return array1;
		}
		if (array1 == null) {
			return array2;
		}
		if (array2 == null) {
			return array1;
		}
		return null;
	}
	
	public static <T> boolean array_key_exists(String key, Map<String, T> map) {
		if(map!=null && map.size()>0){
			for(String keyValue:map.keySet()) {
				if(keyValue!=null && key.equals(keyValue)) {
					return true;
				}
			}
		}
		return false;	
	}
	
	public static <T> List<T> array_unique(List<T> array) {
		Set<T> set=new HashSet<T>();
		List<T> resultList=new ArrayList<T>();
		if(array!=null && array.size()>0) {
			set.addAll(array);
		}
		resultList.addAll(set);
		return resultList;
	}
	
	public static void sort_maps_by(List<Map<String,String>> array, final String key) {
		Collections.sort(array, new Comparator<Map<String,String>>() {

			@Override
			public int compare(Map<String,String> lhs, Map<String,String> rhs) {
				return lhs.get(key).compareTo(rhs.get(key));
			}
		});
	}
	
	public static void sort(List array) {
		Collections.sort(array);
	}
	
	public static int count(List array) {
		if(array!=null) {
			return array.size();
		}
		return 0;
	}
	
	public static int count(Map map) {
		if(map!=null) {
			return map.size();
		}
		return 0;
	}
	
	public static <T> Map<T, Map<String, T>> list_to_map(String key, List<Map<String, T>> inputList) {
		Map<T, Map<String, T>> resultDict = new HashMap<T, Map<String,T>>();
		for (int i = 0; i < inputList.size(); i++) {
			resultDict.put(inputList.get(i).get(key), inputList.get(i));
		}
		return resultDict;
	}
	
	public static <T, U> List<?> Array_values(boolean useKey, Map<T, U> dict) {
		if (useKey) {
			return new ArrayList<T>(dict.keySet());
		}
		List<U> values = new ArrayList<U>();
		for (T key : dict.keySet()) {
			values.add(dict.get(key));
		}
		return values;
	}
}
