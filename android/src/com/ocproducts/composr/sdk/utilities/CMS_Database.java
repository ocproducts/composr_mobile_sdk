package com.ocproducts.composr.sdk.utilities;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseUtils;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
import android.widget.Toast;

/*

CMS_Database (should work via SQLite which doesn't really use field types so we will ignore those)

void add_table_field(string tableName, string fieldName)
void rename_table_field(string tableName, string oldFieldName, string newFieldName)
void delete_table_field(string tableName, string fieldName)
void create_table(string tableName, array fieldNames)
void drop_table_if_exists(string tableName)
string db_escape_string(string value)
array query(string query)
void query_delete(string tableName, map whereMap)
void query_insert(string tableName, map valueMap)
array query_select(string tableName, array selectList, map whereMap, string extraSQL)
string query_select_value(string tableName, string selectFieldName, map whereMap, string extraSQL) - returns blank if no match
int query_select_int_value(string tableName, string selectFieldName, map whereMap, string extraSQL) - returns -1 if no match
void query_update(string tableName, map valueMap, map whereMap)

*/

public class CMS_Database extends SQLiteOpenHelper {
	
    // The Android's default system path of your application database.
    public static String DB_PATH;

    public static String DB_NAME = "cms_DB.sqlite";

    private SQLiteDatabase mDatabase;

    private final Context myContext;
	
	/**
     * Constructor Takes and keeps a reference of the passed context in order to access to the application assets and
     * resources.
     * 
     * @param context
     */
    public CMS_Database(Context context)
    {
        super(context, DB_NAME, null, 1);

        this.myContext = context;
        DB_PATH = context.getFilesDir().getParentFile() + "/databases/";

        try {
            createDatabase();
            close();
        }
        catch (IOException e) {
            Toast.makeText(context, "Error initializing database. If this problem persists, contact support@ocportal.com", Toast.LENGTH_LONG).show();
            e.printStackTrace();
        }
    }

    /**
     * Creates a empty database on the system and rewrites it with your own database.
     */
    public void createDatabase() throws IOException
    {
        boolean dbExists = checkDatabase();

        if (dbExists) {
            // do nothing - database already exist
        }
        else {
            this.getReadableDatabase();
            try {
                copyDatabase();
            }
            catch (IOException e) {
                throw new Error("Error copying database: " + e.getMessage());
            }
        }
    }

    /**
     * Check if the database already exist to avoid re-copying the file each time you open the application.
     * 
     * @return true if it exists, false if it doesn't
     */
    private boolean checkDatabase()
    {
        SQLiteDatabase checkDB = null;

        try {
            String myPath = DB_PATH + DB_NAME;
            File file = new File(myPath);

            if (Constants.DEBUG_MODE && Constants.DATABASE_RESET) {
                file.delete();
            }

            if (file.exists()) {
                checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
            }
        }
        catch (SQLiteException e) {
            e.printStackTrace();
        }

        if (checkDB != null) {
            checkDB.close();
        }

        return checkDB != null ? true : false;
    }

    /**
     * Copies your database from your local assets-folder to the just created empty database in the system folder, from
     * where it can be accessed and handled. This is done by transferring bytestream.
     */
    private void copyDatabase() throws IOException
    {
        // Open your local db as the input stream
        InputStream myInput = myContext.getAssets().open(DB_NAME);

        // Path to the just created empty db
        String outFileName = DB_PATH + DB_NAME;

        // Open the empty db as the output stream
        OutputStream myOutput = new FileOutputStream(outFileName);
        if (myInput != null && myOutput != null) {
            // transfer bytes from the inputfile to the outputfile
            byte[] buffer = new byte[1024];
            int length;
            while ((length = myInput.read(buffer)) > 0) {
                myOutput.write(buffer, 0, length);
            }
        }
        else {
            Log.e("CMS_SDK", "Could not find database in assets");
        }

        // Close the streams
        myOutput.flush();
        myOutput.close();
        myInput.close();
    }

    /**
     * Open database in read write mode
     * 
     * @throws SQLException
     */
    public void openDatabase() throws SQLException
    {
        // Open the database
        String myPath = DB_PATH + DB_NAME;
        mDatabase = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READWRITE);
    }

    /**
     * Open database in readable mode
     * 
     * @return SQLiteDatabase
     */
    public SQLiteDatabase openDatabaseInReadMode()
    {
        return getReadableDatabase();
    }

    /**
     * Open database in writable mode
     * 
     * @return SQLiteDatabase
     */
    public SQLiteDatabase openDatabaseInWritableMode()
    {
        return getWritableDatabase();
    }

    @Override
    public synchronized void close()
    {
        super.close();

        if (mDatabase != null)
            mDatabase.close();
    }

    /**
     * For database support case sensitive & foreign key
     */
    @Override
    public void onOpen(SQLiteDatabase db)
    {
        super.onOpen(db);

        if (!db.isReadOnly()) {
            // Enable foreign key constraints
            db.execSQL("PRAGMA foreign_keys=ON;");
            db.execSQL("PRAGMA case_sensitive_like=ON");
        }
    }

    @Override
    public void onCreate(SQLiteDatabase db)
    {
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion)
    {
    }

    public boolean isTableExists(String tableName, boolean openDb)
    {
        if (openDb) {
            if (mDatabase == null || !mDatabase.isOpen()) {
                mDatabase = getReadableDatabase();
            }

            if (!mDatabase.isReadOnly()) {
                mDatabase.close();
                mDatabase = getReadableDatabase();
            }
        }

        Cursor cursor = mDatabase.rawQuery("SELECT DISTINCT tbl_name FROM sqlite_master WHERE tbl_name = '" + tableName + "'", null);
        if (cursor != null) {
            if (cursor.getCount() > 0) {
                cursor.close();
                return true;
            }
            cursor.close();
        }
        return false;
    }
	
	public void add_table_field(String tableName, String fieldName) {
		String sql = "ALTER TABLE " + tableName + " ADD COLUMN " + fieldName + " TEXT;";
        mDatabase.execSQL(sql);
	}
	
	public void rename_table_field(String tableName, String oldFieldName, String newFieldName) {
		List<String> fieldNames = getFieldNamesForTable(tableName);
		
		if (!fieldNames.contains(oldFieldName)) {
			return;
		}
		
		List<String> newFieldNames = new ArrayList<String>();
		for (String fieldName : fieldNames) {
			if (!fieldName.equals(oldFieldName)) {
				newFieldNames.add(fieldName);
			}
		}
		newFieldNames.add(newFieldName);
		
		List<Map<String, String>> data = query_select(tableName, null, null, "");
		drop_table_if_exists(tableName);
		create_table(tableName, newFieldNames);
		
		for (Map<String, String> row : data) {
			query_insert(tableName, row);
		}
	}
	
	public void delete_table_field(String tableName, String fieldName) {
		List<String> fieldNames = getFieldNamesForTable(tableName);
		
		if (!fieldNames.contains(fieldName)) {
			return;
		}
		
		fieldNames.remove(fieldName);
		
		List<Map<String, String>> data = query_select(tableName, fieldNames, null, "");
		drop_table_if_exists(tableName);
		create_table(tableName, fieldNames);
		
		for (Map<String, String> row : data) {
			query_insert(tableName, row);
		}
	}
	
	public void create_table(String tableName, List<String> fieldNames) {
		String fieldNamesString = CMS_Arrays.implode(",", fieldNames);
		fieldNamesString = fieldNamesString.replaceAll(",", " TEXT, ");
		fieldNamesString += " TEXT";
		String sql = "CREATE TABLE IF NOT EXISTS " + tableName + " ( " + fieldNamesString + " );";
        mDatabase.execSQL(sql);
	}

	public void drop_table_if_exists(String tableName) {
		String sql = "DROP TABLE IF EXISTS " + tableName + " ;";
        mDatabase.execSQL(sql);
	}
	
	public String db_escape_string(String sql) {
		return DatabaseUtils.sqlEscapeString(sql);
	}
	
	public List<Map<String, String>> query(String query) {
		List<Map<String, String>> data = new ArrayList<Map<String,String>>();
		try {
			Cursor cursor = mDatabase.rawQuery(query, null);
			if (cursor != null) {
			    if (cursor.moveToFirst()) {
			        do {
			        	HashMap<String, String> row = new HashMap<String, String>();
			        	for (int i = 0; i < cursor.getColumnCount(); i++) {
							row.put(cursor.getColumnName(i), cursor.getString(i));
						}
			        	data.add(row);
			        }
			        while (cursor.moveToNext());
			    }
			    cursor.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
        return data;
	}
	
	public void query_delete(String tableName, Map<String, String> whereMap) {
		String sql = "DELETE FROM " + tableName + " WHERE " + convertWhereMapToSQL(whereMap, "AND") + " ;";
		mDatabase.execSQL(sql);
	}
	
	public void query_insert(String tableName, Map<String, String> valueMap) {
		String sql = "INSERT INTO " + tableName + " " + convertValueMapToInsertSQL(valueMap) + " ;";
		mDatabase.execSQL(sql);
	}
	
	public List<Map<String, String>> query_select(String tableName, List<String> selectList, Map<String, String> whereMap, String extraSQL) {
		String sql = "SELECT " + (selectList != null && selectList.size() > 0 ? CMS_Arrays.implode(",", selectList) : "*") + " FROM " + tableName;
		if (whereMap != null && whereMap.size() > 0) {
			sql += " WHERE " + convertWhereMapToSQL(whereMap, "AND");
		}
		if (extraSQL != null) {
			sql += " " + extraSQL;
		}
		sql += " ;";
		return query(sql);
	}
	
	public String query_select_value(String tableName, String selectFieldName, Map<String, String> whereMap, String extraSQL) {
		ArrayList<String> selectFieldList = new ArrayList<String>();
		selectFieldList.add(selectFieldName);
		List<Map<String, String>> result = query_select(tableName, selectFieldList, whereMap, extraSQL);
		if (result.size() > 0) {
			Map<String, String> row = result.get(0);
			if (row.get(selectFieldName) != null) {
				return row.get(selectFieldName);
			}
		}
		return "";
	}
	
	public int query_select_int_value(String tableName, String selectFieldName, Map<String, String> whereMap, String extraSQL) {
		String stringResult = query_select_value(tableName, selectFieldName, whereMap, extraSQL);
		if (stringResult != null && !stringResult.trim().equals("")) {
			try {
				return Integer.parseInt(stringResult);
			} catch (NumberFormatException e) {
				return -1;
			}
		}
		return -1;
	}
	
	public void query_update(String tableName, Map<String, String> valueMap, Map<String, String> whereMap) {
		String sql = "UPDATE " + tableName + " SET " + convertWhereMapToSQL(valueMap, ",") + " WHERE " + convertWhereMapToSQL(whereMap, "AND") + " ;";
		mDatabase.execSQL(sql);
	}
	
	public List<String> getFieldNamesForTable(String tableName) {
		List<String> fieldNames = new ArrayList<String>();
		String sql = "PRAGMA table_info(" + tableName + ");";
		Cursor cursor = mDatabase.rawQuery(sql, null);
        if (cursor != null) {
            if (cursor.moveToFirst()) {
            	do {
            		fieldNames.add(cursor.getString(1));
                }
                while (cursor.moveToNext());
            }
            cursor.close();
        }
        return fieldNames;
	}
	
	public String convertWhereMapToSQL(Map<String, String> whereMap, String conjunction) {
		String whereSQL = "";
		String[] keys = (String[]) whereMap.keySet().toArray(new String[whereMap.size()]);
		for (int i = 0; i < keys.length; i++) {
			whereSQL += keys[i] + " = ";
			whereSQL += "'" + whereMap.get(keys[i]) + "'";
			if (i != keys.length-1) {
				whereSQL += " " + conjunction + " ";
			}
		}
		return whereSQL;
	}
	
	public String convertValueMapToInsertSQL(Map<String, String> valueMap) {
		StringBuilder sb = new StringBuilder();
		sb.append("(");
		
		String[] keys = (String[]) valueMap.keySet().toArray(new String[valueMap.size()]);
		for (int i = 0; i < keys.length; i++) {
			sb.append(keys[i]);
			if (i != keys.length-1) {
				sb.append(", ");
			}
		}
		
		sb.append(") VALUES (");
		
		for (int i = 0; i < keys.length; i++) {
			sb.append("'" + valueMap.get(keys[i]) + "'");
			if (i != keys.length-1) {
				sb.append(", ");
			}
		}
		
		sb.append(")");
		
		return sb.toString();
	}
}
