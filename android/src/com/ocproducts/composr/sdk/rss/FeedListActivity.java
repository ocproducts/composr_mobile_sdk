package com.ocproducts.composr.sdk.rss;

import com.ocproducts.composr.sdk.R;
import com.ocproducts.composr.sdk.rss.parser.RSSFeed;
import com.ocproducts.composr.sdk.rss.parser.RSSUtil;
import com.ocproducts.composr.sdk.rss.util.LoadRSSFeed;
import com.ocproducts.composr.sdk.rss.util.LoadRSSFeed.LoadRSSFeedCallback;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.AdapterView.OnItemClickListener;

public class FeedListActivity extends Activity implements LoadRSSFeedCallback {

	private ListView mList;
	RSSFeed feed;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feed_list);
        mList = (ListView) findViewById(R.id.list);

        mList.setVerticalFadingEdgeEnabled(true);
        
        String feedUrl = getIntent().getExtras().getString("url");
        if (feedUrl != null && !feedUrl.trim().equals("")) {
			RSSUtil.RSSFEEDURL = feedUrl;
		}
        new LoadRSSFeed(this, RSSUtil.RSSFEEDURL).execute();
        
	}

	@Override
	public void finishedParsingFeed(RSSFeed feed) {
		// Get feed from the passed bundle
		this.feed = feed;
		// Create a new adapter
		ListAdapter adapter = new ListAdapter(this, feed);
		// Set the adapter to the list
		mList.setAdapter(adapter);

		// Set on item click listener to the ListView
		mList.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
				// Start the new activity and pass on the feed item
				Intent intent = new Intent(android.content.Intent.ACTION_VIEW);
				intent.setComponent(new ComponentName(getPackageName(), "com.ocproducts.composr.sdk.rss.FeedDetail"));
				startActivity(intent.putExtra("pos", arg2));
			}
		});
	}
}
