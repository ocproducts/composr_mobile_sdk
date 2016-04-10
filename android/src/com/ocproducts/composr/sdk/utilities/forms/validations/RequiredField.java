package com.ocproducts.composr.sdk.utilities.forms.validations;

import com.ocproducts.composr.sdk.R;

import android.content.res.Resources;

/**
 * Represents a validation error where input is missing for a required field.
 */
public class RequiredField extends ValidationError {

    /**
     * Creates a new instance with the specified field name.
     *
     * @param fieldName     the field name
     * @param fieldLabel    the field label
     */
    public RequiredField(String fieldName, String fieldLabel) {
        super(fieldName, fieldLabel);
    }

    @Override
    public String getMessage(Resources resources) {
        return String.format(resources.getString(R.string.required_field_error_msg), getFieldLabel());
    }
}
