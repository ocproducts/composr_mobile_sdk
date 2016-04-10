package com.ocproducts.composr.sdk.rss;

import com.ocproducts.composr.sdk.rss.parser.RSSFeed;
import com.ocproducts.composr.sdk.rss.parser.RSSUtil;
import com.ocproducts.composr.sdk.rss.util.WriteObjectFile;

import android.annotation.SuppressLint;
import android.os.Bundle;

@SuppressLint("SetJavaScriptEnabled")
public class FeedDetail extends InlineBrowser {

	// Our RSS feed object
	private RSSFeed feed;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// Get the feed object
		feed = (RSSFeed)new WriteObjectFile(this).readObject(RSSUtil.getFeedName());
		// Get the position from the intent
		int position = getIntent().getExtras().getInt("pos");
		// Set the title based on the post
		setTitle(feed.getItem(position).getTitle());
		// Load the URL
		browser.getSettings().setJavaScriptEnabled(true);
		browser.loadDataWithBaseURL("", feed.getItem(position).getDescription(), "text/html", "UTF-8", "");
	}
}
