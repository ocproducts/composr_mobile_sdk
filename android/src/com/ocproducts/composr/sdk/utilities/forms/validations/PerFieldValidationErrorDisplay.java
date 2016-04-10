package com.ocproducts.composr.sdk.utilities.forms.validations;

import android.content.Context;
import android.content.res.Resources;

import java.util.List;

import com.ocproducts.composr.sdk.utilities.forms.FormController;
import com.ocproducts.composr.sdk.utilities.forms.FormElementController;
import com.ocproducts.composr.sdk.utilities.forms.controllers.FormSectionController;

public class PerFieldValidationErrorDisplay implements ValidationErrorDisplay {
    private final Context context;
    private final FormController controller;

    public PerFieldValidationErrorDisplay(Context context, FormController controller) {
        this.context = context;
        this.controller = controller;
    }

    @Override
    public void resetErrors() {
        for (FormSectionController section: controller.getSections()) {
            for (FormElementController elementController: section.getElements()) {
                elementController.setError(null);
            }
         }
    }

    @Override
    public void showErrors(List<ValidationError> errors) {
        Resources res = context.getResources();
        FormElementController element;
        for (ValidationError error : errors) {
            element = controller.getElement(error.getFieldName());
            element.setError(error.getMessage(res));
        }
    }
}
