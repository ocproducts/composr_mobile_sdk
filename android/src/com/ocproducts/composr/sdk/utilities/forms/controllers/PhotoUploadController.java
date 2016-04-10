package com.ocproducts.composr.sdk.utilities.forms.controllers;

import com.ocproducts.composr.sdk.R;
import android.app.Activity;
import android.app.Dialog;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;

public class PhotoUploadController extends LabeledFieldController {

	public static final int RESULT_GALLERY=1001;
	public static final int RESULT_CAMERA=1002;
	private Bitmap defaultImage;
	private Context context;
	private Uri imageUri;
	private ImageView clickableImage;

	public PhotoUploadController(Context ctx, String name, String labelText,
			boolean isRequired, Bitmap defaultImage) {
		super(ctx, name, labelText, isRequired);
		this.defaultImage = defaultImage;
		this.context = ctx;
	}

	@Override
	protected View createFieldView() {
		LayoutInflater inflater = (LayoutInflater) getContext()
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		ViewGroup ImageViewContainer = (ViewGroup) inflater.inflate(
				R.layout.form_photo_upload_container, null);

		clickableImage = new ImageView(getContext());
		clickableImage.setImageBitmap(defaultImage);
		clickableImage.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				final Dialog dialog = new Dialog(getContext());
				dialog.setContentView(R.layout.form_image_3button_dialog);
				dialog.setTitle("Select");
				Button cameraButton = (Button) dialog.findViewById(R.id.camera);
				Button galleryButton = (Button) dialog.findViewById(R.id.gallery);
				Button cancelButton = (Button) dialog.findViewById(R.id.cancel);
				dialog.show();

				cameraButton.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						Intent intent = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
						((Activity) context).startActivityForResult(intent, RESULT_CAMERA);

					}
				});

				galleryButton.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						 Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("content://media/internal/images/media")); 
						((Activity) context).startActivityForResult(intent, RESULT_GALLERY);

					}
				});
				
				cancelButton.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						dialog.cancel();
						
					}
				});
			}
		});
		ImageViewContainer.addView(clickableImage);

		return ImageViewContainer;
	}
	public void startActivityForResult(Intent i, int code)
	{
	    Log.e("", "OnActivityResult "+code);
	    if (code==RESULT_CAMERA) {
	    	Uri selectedImage = imageUri;
            context.getContentResolver().notifyChange(selectedImage, null);
           
            ContentResolver cr = context.getContentResolver();
            Bitmap bitmap;
            try {
                 bitmap = android.provider.MediaStore.Images.Media
                 .getBitmap(cr, selectedImage);

                 clickableImage.setImageBitmap(bitmap);
               
            } catch (Exception e) {
                Log.e("Camera", e.toString());
            }
		}
	    else if (code==RESULT_GALLERY) {
	    	 Uri selectedImage = i.getData();
	            String[] filePathColumn = { MediaStore.Images.Media.DATA };
	            Cursor cursor = context.getContentResolver().query(selectedImage,filePathColumn, null, null, null);
	            cursor.moveToFirst();
	            int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
	            String picturePath = cursor.getString(columnIndex);
	            cursor.close();
	           
	            clickableImage.setImageBitmap(BitmapFactory.decodeFile(picturePath));
		}
	}

	@Override
	public void refresh() {
		 getContainer();

	}
	
	private ViewGroup getContainer() {
        return (ViewGroup) getView().findViewById(R.id.form_photo_upload_container);
    }

}
